require './lib/location_tracker'

describe 'track rake task' do
  it 'should track' do
    load File.expand_path('../../../Rakefile', __FILE__)
    expect_any_instance_of(LocationTracker).to receive(:track).once

    Rake::Task['track'].invoke
  end
end
