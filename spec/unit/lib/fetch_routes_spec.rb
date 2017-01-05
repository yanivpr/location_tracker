require 'rspec'
require 'fetch_routes'
require 'httparty'

RSpec.describe FetchRoutes do
  it 'fetches and uncomresses data' do
    class FetchTest
      include FetchRoutes

      def fetch_routes
        data = call[required_files[0]]
      end

      def source_name
        'test_source_name'
      end

      def required_files
        %w(test/data.txt)
      end
    end

    data = File.read('spec/fixtures/test.zip')
    allow(Configuration).to receive(:service_url).and_return('some_url')
    allow(Configuration).to receive(:service_passphrase).and_return('some_passphrase')

    http_response = Object.new
    allow(HTTParty).
      to receive(:get).
      with('some_url?source=test_source_name&passphrase=some_passphrase').
      and_return(http_response)
    allow(http_response).to receive(:parsed_response).and_return(data)

    response = FetchTest.new.fetch_routes

    expect(response).to eq("Some test data\n")
  end
end
