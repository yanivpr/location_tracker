require 'rspec'

RSpec.shared_examples 'fetch_routes' do |fixture_name, fetch_class, expected_routes|
  it 'returns correct routes' do
    routes_data = File.read(fixture_name)
    allow(HTTParty).
      to receive_message_chain(:get, :parsed_response).
      and_return(routes_data)

    routes = fetch_class.new.fetch_routes

    expect(expected_routes.size).to eq(routes.size)

    routes.each_with_index do |route, index|
      expect_route(route, expected_routes[index])
    end
  end

  def expect_route(actual_route, expected_route)
    expect(expected_route.start_node).to eq(actual_route.start_node)
    expect(expected_route.end_node).to eq(actual_route.end_node)
    expect(expected_route.start_time).to eq(actual_route.start_time)
    expect(expected_route.end_time).to eq(actual_route.end_time)
  end
end
