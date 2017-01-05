require 'rspec'
require 'sentinels'
require 'route'
require_relative 'fetch_routes_shared_examples'

RSpec.describe Sentinels do
  expected_routes = [
    Route.new(
      'alpha',
      'gamma',
      Time.parse('2030-12-31T13:00:01+00:00'),
      Time.parse('2030-12-31T13:00:03+00:00')
    ),
    Route.new(
      'delta',
      'gamma',
      Time.parse('2030-12-31T13:00:02+00:00'),
      Time.parse('2030-12-31T13:00:04+00:00')
    ),
    Route.new(
      'zeta',
      'zeta',
      Time.parse('2030-12-31T13:00:02+00:00'),
      Time.parse('2030-12-31T13:00:02+00:00')
    )
  ]
  
  it_behaves_like 'fetch_routes', 'spec/fixtures/sentinels.zip', described_class, expected_routes
end
