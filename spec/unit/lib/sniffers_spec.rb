require 'rspec'
require 'sniffers'
require 'route'
require_relative 'fetch_routes_shared_examples'

RSpec.describe Sniffers do
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

  it_behaves_like 'fetch_routes', 'spec/fixtures/sniffers.zip', described_class, expected_routes
end
