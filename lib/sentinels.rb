require_relative 'source_names'
require_relative 'fetch_routes'
require_relative 'csv_parser'
require_relative 'route'
require 'time'

class Sentinels
  include FetchRoutes
  include CSVParser

  # Fetch sentinels routes
  # @return [Route] parsed routes
  def fetch_routes
    data = call[required_files[0]]
    csv = to_hash(data)
    casted_csv = cast(csv)
    routes_sorted = start_end_nodes(casted_csv)
    to_routes(routes_sorted)
  end

  def source_name
    SourceNames::SENTINELS
  end

  private

  def cast(csv)
    csv.each do |row|
      row['route_id'] = row['route_id'].to_i
      row['index'] = row['index'].to_i
      row['time'] = Time.parse(row['time']).utc
    end
  end

  def start_end_nodes(casted_csv)
    casted_csv.group_by { |row| row['route_id'] }.map do |route_id, data|
      { route_id => [data.min { |node| node['index'] }, data.max { |node| node['index'] }] }
    end
  end

  def to_routes(routes_sorted)
    routes_sorted.map do |route|
      route_edges = route.values.first
      start_node_data = route_edges[0]
      end_node_data = route_edges[1]
      Route.new(
        start_node_data['node'],
        end_node_data['node'],
        start_node_data['time'],
        end_node_data['time']
      )
    end
  end

  def required_files
    %w(sentinels/routes.csv)
  end
end
