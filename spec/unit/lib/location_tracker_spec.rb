require 'rspec'
require 'location_tracker'

RSpec.describe LocationTracker do
  describe '#track' do
    it 'calls import with correct data' do
      class TestImportRoute; end
      import_route = TestImportRoute.new

      route_one_1 = Object.new
      route_one_2 = Object.new

      class TestSourceOne
        def initialize(routes)
          @routes = routes
        end

        def fetch_routes
          @routes
        end

        def source_name
          'One'
        end
      end

      route_two_1 = Object.new
      route_two_2 = Object.new

      class TestSourceTwo
        def initialize(routes)
          @routes = routes
        end

        def fetch_routes
          @routes
        end

        def source_name
          'Two'
        end
      end
      location_tracker = LocationTracker.new(
        TestSourceOne.new([route_one_1, route_one_2]),
        TestSourceTwo.new([route_two_1, route_two_2]),
        import_route
      )

      expect(import_route).to receive(:call).with('One', route_one_1)
      expect(import_route).to receive(:call).with('One', route_one_2)
      expect(import_route).to receive(:call).with('Two', route_two_1)
      expect(import_route).to receive(:call).with('Two', route_two_2)

      location_tracker.track
    end
  end
end
