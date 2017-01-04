require 'rspec'
require 'csv_parser'

RSpec.describe CSVParser do
  it 'parses csv data into an array of hashes' do
    csv_data = "header1, header2\nvalue1, value2"

    result = CSVParser.to_hash(csv_data)

    expect(result).to eq(['header1' => 'value1', 'header2' => 'value2'])
  end
end
