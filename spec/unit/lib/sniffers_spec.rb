require 'rspec'
require 'sniffers'
require 'route'

RSpec.describe Sniffers do
  it 'returns correct routes' do
    sentinels_data = File.read('spec/fixtures/sniffers.zip')
    allow(HTTParty).
      to receive_message_chain(:get, :parsed_response).
      and_return(sentinels_data)

    routes = Sniffers.new.fetch_routes

    expected_routes = [
      Route.new(
        'lambda',
        'omega',
        Time.parse('2030-12-31T13:00:06+00:00'),
        Time.parse('2030-12-31T13:00:09+00:00')
      ),
      Route.new(
        'lambda',
        'omega',
        Time.parse('2030-12-31T13:00:07+00:00'),
        Time.parse('2030-12-31T13:00:09+00:00')
      )
    ]

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
