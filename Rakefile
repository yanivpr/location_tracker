require './lib/location_tracker'
require './lib/sentinels'
require './lib/sniffers'
require './lib/loopholes'
require './lib/import_route'
require 'rake'

task default: [:track]

task :track do
  tracker = LocationTracker.new(Sentinels.new, Sniffers.new, Loopholes.new, ImportRoute.new)
  tracker.track
  STDOUT.print "Tracking done\n"
end
