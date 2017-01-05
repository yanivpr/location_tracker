# Tracks location - fetches routes from various sources and import them to the system.
class LocationTracker
  # Create an instance of +LocationTracker+.
  # @param [*Source] sources - the sources we wish to fetch from. Either Sentinels, Sniffers and Loopholes.
  # @param [ImportRoute] import_route - a service that imports routes to the system.
  def initialize(*sources, import_route)
    @sources = sources
    @import_route = import_route
  end

  # Tracks location - fetches and imports to system.
  def track
    source_names_routes = fetch_routes

    import_routes(source_names_routes)
  end

  private

  def fetch_routes
    @sources.each_with_object({}) do |source, data|
      begin
        data[source.source_name] = source.fetch_routes
      rescue StandardError => error
        STDOUT.print("Failed to fetch routes for '#{source.source_name}'")
      end
    end
  end

  def import_routes(source_names_routes)
    source_names_routes.each do |source_name, routes|
      routes.each do |route|
        begin
          @import_route.call(source_name, route)
        rescue StandardError => error
          STDOUT.print("Failed to import route '#{route.to_s}' for '#{source_name}'")
        end
      end
    end
  end
end
