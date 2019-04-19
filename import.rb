require './wire_parser'
require 'pp'
require 'csv'

parser = WireParser.new

csv = CSV.read("data.csv", headers: false, col_sep: ';')
csv[1..-1].each do |row|
  begin
    name = row[0]
    wire = parser.parse_with_debug name
    pp wire[:line] if wire
  rescue Parslet::ParseFailed => failure
    puts "Error: #{name}"
    #puts failure.parse_failure_cause.ascii_tree
  end
end
