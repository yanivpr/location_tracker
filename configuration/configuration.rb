require 'yaml'
require 'ostruct'

yaml = YAML.load_file("#{__dir__}/configuration.yml")
Configuration = OpenStruct.new(yaml)
