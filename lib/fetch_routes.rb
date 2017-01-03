require './configuration/configuration'
require 'httparty'
require 'zip'

# Fetchs raw routes data from a specific source
module FetchRoutes
  extend self

  # Fetch uncompressed raw routes data for a specific source
  # @param [String] source_name - source to fetch data from
  # @return [Hash<filename, Hash>] - filenames and their content
  def call
    uncompress(fetch_raw_routes_data)
  end

  private

  def fetch_raw_routes_data
    url = Configuration::SERVICE_URL
    passphrase = Configuration::SERVICE_PASSPHRASE
    full_url = URI.encode("#{url}?#{params(passphrase, source_name)}")

    HTTParty.get(full_url).parsed_response
  end

  def uncompress(raw_data)
    uncompressed_data = {}
    File.open('tmpzipfile', 'wb') { |zip_file| zip_file.write(raw_data) }

    Zip::File.open('tmpzipfile') do |zip_file|
      zip_file.each do |entry|
        if required_files.include?(entry.name)
          uncompressed_data[entry.name] = entry.get_input_stream.read
        end
      end
    end

    File.delete('tmpzipfile')

    uncompressed_data
  end

  def params(passphrase, source_name)
    {
      source: source_name,
      passphrase: passphrase
    }.map { |key, value| "#{key}=#{value}"}
    .join('&')
  end
end
