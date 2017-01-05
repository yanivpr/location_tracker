require 'rspec'
require 'route'

RSpec.describe Route do
  context 'it has correct attribtues' do
    subject do
      route = Route.new(
        'alpha',
        'beta',
        Time.parse('2030-12-31T04:06:07+00:00').utc,
        Time.parse('2030-12-31T04:06:10+00:00').utc
      )
    end

    it 'start_node' do
      expect(subject.start_node).to eq('alpha')
    end

    it 'end_node' do
      expect(subject.end_node).to eq('beta')
    end

    it 'start_time' do
      expect(subject.start_time).to eq(Time.parse('2030-12-31T04:06:07+00:00'))
    end

    it 'end_time' do
      expect(subject.end_time).to eq(Time.parse('2030-12-31T04:06:10+00:00'))
    end
  end

  describe '#to_s' do
    it do
      route = Route.new(
        'alpha',
        'beta',
        Time.parse('2030-12-31T04:06:07+00:00').utc,
        Time.parse('2030-12-31T04:06:10+00:00').utc
      )

      expect(route.to_s).to eq('alpha (2030-12-31 04:06:07 UTC) -> beta (2030-12-31 04:06:10 UTC)')
    end
  end
end
