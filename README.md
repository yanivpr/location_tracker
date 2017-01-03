# Location Tracker

A ruby program that tracks routes.
It downloads routes from different sources, parses them and imports to the system.
It is invoked by a rake task.


## Track
bundle exec rake

## Run specs
bundle exec rspec

## what is missing
- error handling (fail download, fail import, retry)
- validation of possible node names
- specs for the download module
- specs for the import module
- functional test - mock download data and expect a specific upload
- passphrase in environment variable instead of plain text in code
- extract CSV reading module
