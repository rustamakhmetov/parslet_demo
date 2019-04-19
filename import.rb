# frozen_string_literal: true

require './wire_parser'
require 'pp'
require 'csv'

parser = WireParser.new

csv = CSV.read('data.csv', headers: false, col_sep: ';')
csv[1..-1].each do |row|
  name = row[0]
  wire = parser.parse_with_debug name
  if wire
    pp wire[:line]
    puts wire[:line][:model]
  end
rescue Parslet::ParseFailed => e
  puts "Error: #{name}"
  puts e.parse_failure_cause.ascii_tree
end
