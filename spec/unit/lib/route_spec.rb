require 'rspec'
require 'route'

RSpec.describe Route do
  context 'it has correct attribtues' do
    let(:start_node) { 'alpha' }
    let(:end_node) { 'beta' }
    let(:start_time) { Time.parse('2030-12-31T04:06:07') }
    let(:end_time) { Time.parse('2030-12-31T04:06:10') }

    subject { Route.new(start_node, end_node, start_time, end_time) }

    it 'start_node' do
      expect(subject.start_node).to eq(start_node)
    end

    it 'end_node' do
      expect(subject.end_node).to eq(end_node)
    end

    it 'start_time' do
      expect(subject.start_time).to eq(start_time)
    end

    it 'end_time' do
      expect(subject.end_time).to eq(end_time)
    end
  end
end
