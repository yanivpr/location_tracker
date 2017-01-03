require_relative 'source_names'
require_relative 'fetch_routes'
require_relative 'route'
require 'json'
require 'time'

class Loopholes
  include FetchRoutes

  # Fetch loopholes routes
  # @return [Route] parsed routes
  def fetch_routes
    data = call
    routes_data = data[required_files[0]]
    node_pairs_data = data[required_files[1]]

    routes_json = JSON.parse(routes_data)['routes']
    node_pairs_json = JSON.parse(node_pairs_data)['node_pairs']

    to_routes(routes_json, node_pairs_json)
  end

  def source_name
    SourceNames::LOOPHOLES
  end

  private

  def to_routes(routes, node_pairs)
    routes_nodes = routes.map do |route|
      id = route['node_pair_id']
      node_pair = node_pairs.find { |node| node['id'] == id }

      route.merge(node_pair) if node_pair
    end.compact

    routes_nodes.group_by { |route| route['route_id'] }.map do |id, route_node|
      start_node = route_node.first['start_node']
      end_node = route_node.last['end_node']
      start_time = Time.parse(route_node.first['start_time'])
      end_time = Time.parse(route_node.last['end_time'])

      Route.new(start_node, end_node, start_time, end_time)
    end
  end

  def required_files
    %w(loopholes/routes.json loopholes/node_pairs.json)
  end
end
