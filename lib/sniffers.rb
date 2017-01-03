require_relative 'source_names'
require_relative 'fetch_routes'
require_relative 'route'
require 'csv'
require 'uri'
require 'time'

class Sniffers
  include FetchRoutes

  # Fetch sniffers routes
  # @return [Route] parsed routes
  def fetch_routes
    data = call
    routes_data = data[required_files[0]]
    node_times_data = data[required_files[1]]
    sequences_data = data[required_files[2]]

    csv_routes = to_csv(routes_data)
    csv_node_times = to_csv(node_times_data)
    csv_sequences = to_csv(sequences_data)

    casted_routes = cast_routes(csv_routes)
    casted_node_times = cast_node_times(csv_node_times)
    casted_sequences = cast_sequences(csv_sequences)

    to_routes(casted_routes, casted_node_times, casted_sequences)
  end

  def source_name
    SourceNames::SNIFFERS
  end

  private

  def to_csv(raw_data)
    csv = CSV.parse(raw_data, col_sep: ', ')
    headers = csv.shift
    csv.map { |value| Hash[ headers.zip(value) ] }
  end

  def cast_routes(csv)
    csv.each do |row|
      row['route_id'] = row['route_id'].to_i
      time_zone = row['time_zone'].bytes.pack('c*').force_encoding('UTF-8')
      row['time'] = Time.parse(row['time'] + time_zone)
    end
  end

  def cast_sequences(csv)
    csv.each do |row|
      row['route_id'] = row['route_id'].to_i
      row['node_time_id'] = row['node_time_id'].to_i
    end
  end

  def cast_node_times(csv)
    csv.each do |row|
      row['node_time_id'] = row['node_time_id'].to_i
      row['duration_in_milliseconds'] = row['duration_in_milliseconds'].to_i
    end
  end

  def to_routes(casted_routes, casted_node_times, casted_sequences)
    casted_routes.map do |route|
      route_id = route['route_id']
      sequences = casted_sequences.select { |sequence| sequence['route_id'] == route_id }
      nodes = sequences.map do |sequence|
        node_time_id = sequence['node_time_id']
        casted_node_times.find { |node_time| node_time['node_time_id'] == node_time_id }
      end.compact

      next if nodes.empty?

      first_node = nodes.first['start_node']
      last_node = nodes.last['end_node']
      duration_seconds = nodes.sum { |node| node['duration_in_milliseconds'] } / 1000
      Route.new(first_node, last_node, route['time'], route['time'] + duration_seconds)
    end.compact
  end

  def required_files
    %w(sniffers/routes.csv sniffers/node_times.csv sniffers/sequences.csv)
  end
end
