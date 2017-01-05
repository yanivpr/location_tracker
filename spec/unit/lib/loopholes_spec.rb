require 'rspec'
require 'loopholes'
require 'route'
require_relative 'fetch_routes_shared_examples'

RSpec.describe Loopholes do
  expected_routes = [
    Route.new(
    'gamma',
    'lambda',
    Time.parse('2030-12-31T13:00:04+00:00'),
    Time.parse('2030-12-31T13:00:06+00:00')
    ),
    Route.new(
    'beta',
    'lambda',
    Time.parse('2030-12-31T13:00:05+00:00'),
    Time.parse('2030-12-31T13:00:07+00:00')
    )
  ]

  it_behaves_like 'fetch_routes', 'spec/fixtures/loopholes.zip', described_class, expected_routes
end
