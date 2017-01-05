require 'rspec'
require 'import_route'
require 'route'

RSpec.describe ImportRoute do
  describe '#call' do
    it 'makes a correct request' do
      source_name = 'sniffers'
      route = Route.new(
        'alpha',
        'beta',
        Time.parse('2030-12-31T04:06:07+00:00'),
        Time.parse('2030-12-31T04:06:10+00:00')
      )
      allow(Configuration).to receive(:service_url).and_return('some_url')
      allow(Configuration).to receive(:service_passphrase).and_return('some_passphrase')
      import_route = ImportRoute.new

      expect(HTTParty).
        to receive(:post).
        with('some_url?source=sniffers&passphrase=some_passphrase&start_node=alpha&end_node=beta&start_time=2030-12-31T04:06:07&end_time=2030-12-31T04:06:10')

      import_route.call(source_name, route)
    end
  end
end
