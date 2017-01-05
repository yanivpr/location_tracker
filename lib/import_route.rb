require 'httparty'
require 'uri'
require 'time'
require './configuration/configuration'

# Import a single route into the system
class ImportRoute
  # Import a route into the system.
  # @param [String] source_name - one of the possible sources the system accepts.
  # @param [Route] route - an object representing a route.
  def call(source_name, route)
    url = Configuration.service_url
    passphrase = Configuration.service_passphrase
    full_url = URI.encode("#{url}?#{params(route, passphrase, source_name)}")

    HTTParty.post(full_url)
  end

  private

  def params(route, passphrase, source_name)
    {
      source: source_name,
      passphrase: passphrase,
      start_node: route.start_node,
      end_node: route.end_node,
      start_time: route.start_time.strftime("%FT%T"),
      end_time: route.end_time.strftime("%FT%T"),
    }.map { |key, value| "#{key}=#{value}"}
    .join('&')
  end
end
