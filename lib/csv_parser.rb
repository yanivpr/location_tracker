require 'csv'

module CSVParser
  extend self

  # Parses CSV data with headers into an array of hashes
  # @param [String] data - data in csv format
  # @return [Array<Hash>] headers are the hash keys and rows are values
  # @example
  #   data = "header1", "header2"\n"value1", "value2"
  #   result = [{ "header1" => "value1", "header2" => "value2" }]
  def to_hash(data)
    csv = CSV.parse(data, col_sep: ', ')
    headers = csv.shift
    csv.map { |value| Hash[ headers.zip(value) ] }
  end
end
