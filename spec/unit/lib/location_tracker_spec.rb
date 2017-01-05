require 'rspec'
require 'location_tracker'

RSpec.describe LocationTracker do
  describe '#track' do
    it 'fetchs and imports correct data' do
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

    it 'does not import source that failed fetching' do
      class TestImportRoute; end
      import_route = TestImportRoute.new

      class TestFailingSource
        def fetch_routes
          raise 'fecthing routes failed'
        end

        def source_name
          'Failing'
        end
      end

      route = Object.new

      class TestSucceedingSource
        def initialize(routes)
          @routes = routes
        end

        def fetch_routes
          @routes
        end

        def source_name
          'Succeeding'
        end
      end

      location_tracker = LocationTracker.new(
        TestFailingSource.new,
        TestSucceedingSource.new([route]),
        import_route
      )

      expect(import_route).to receive(:call).with('Succeeding', route)
      expect(STDOUT).to receive(:print).with("Failed to fetch routes for 'Failing'")

      location_tracker.track
    end

    it 'skips failing import a route' do
      class TestImportRoute; end
      import_route = TestImportRoute.new

      route_1 = 'err route'
      route_2 = Object.new

      class TestSource
        def initialize(routes)
          @routes = routes
        end

        def fetch_routes
          @routes
        end

        def source_name
          'test_source'
        end
      end

      location_tracker = LocationTracker.new(
        TestSource.new([route_1, route_2]),
        import_route
      )

      allow(import_route).
        to receive(:call).
        with('test_source', route_1).
        and_raise('some error')

      expect(import_route).to receive(:call).with('test_source', route_2)
      expect(STDOUT).to receive(:print).with("Failed to import route 'err route' for 'test_source'")

      location_tracker.track
    end
  end
end
