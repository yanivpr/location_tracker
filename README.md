# Location Tracker

A ruby program that tracks routes.

It downloads routes from different sources, parses them and imports to the system.

It is invoked by a rake task.


## Track
In order to invoke downloading the routes from the various sources and import the to the system:

    bundle install
    bundle exec rake

## Run specs
    bundle exec rspec

## Possible improvements
- sophisticated error handling (fail download, fail import, retrying)
- validation of route node names and times
- passphrase in environment variable instead of plain text in code
- logging
