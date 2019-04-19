require 'parslet'
require 'parslet/convenience'
require 'pp'

class ConfigParser < Parslet::Parser
  rule(:name) { match("\\w").repeat(1).as(:name) }
  rule(:whitespace) { match("[ \\t]").repeat(1) }
  rule(:assigment) { whitespace.maybe >> str("=") >> whitespace.maybe }
  rule(:newline) { str("\n") | str("\r\n") }
  rule(:value) do
    str('"') >>
    (str('"').absent? >> any).repeat.as(:string) >>
    str('"')
  end
  rule(:item) { name >> assigment >> value.as(:value) >> newline }
  rule(:document) { (item.repeat).as(:document) >> newline.repeat }

  root :document
end

class WireParser < Parslet::Parser
  rule(:caption) { str('Провод') }
  rule(:numbers) { match('[0-9]').repeat }
  rule(:up_letters) { match('^[А-Я]').repeat }
  rule(:small_letters) { match('[а-я]').repeat }
  rule(:whitespace) { match("[ \\t,]").repeat }

  rule(:name1) { up_letters }
  rule(:name2) { up_letters >> small_letters >> up_letters }

  rule(:model) do
    (
      (name2 | name1) >>
      (str('-').maybe >> (up_letters | numbers).maybe)
    ).as(:model)
  end

  rule(:diameter) { numbers >> str(',') >> numbers | numbers}
  rule(:size) { ((diameter >> match('[xх]')).maybe >> diameter >> (str('/') >> diameter).maybe).as(:size) }

  rule(:color) { (small_letters >> (str('-') >> small_letters).maybe).as(:color) }

  rule(:tu) { str('ТУ') >> whitespace >> match('[0-9\.-]').repeat.as(:tu) }
  rule(:gost) { str('ГОСТ').as(:gost) }

  rule(:line) do
    (caption.maybe >>
      whitespace.maybe >>
        model >>
        whitespace.maybe >>
        size.maybe >>
        whitespace.maybe >>
        color.maybe >>
        whitespace.maybe >>
        (tu.maybe | gost.maybe).as(:tech)

    ).as(:line)
  end

  root :line
end

data = [
  'ПЭТД-180 1x0,28',
  'Провод ПЭТВ-2 0,950 ТУ 16-705-110-79',
  'Провод ПуГВ 1x6, зеленый-желтый ТУ 16-705.501-2010',
  'Провод АПБ 5,20х12,50/0,45 прям.сеч.',
  'ПуГВ-ХЛ 2х16 ГОСТ',
  'Провод АПБ 5,20х12,50/0,45',
  'ПуГВ-100-ХЛ 2х16 ГОСТ'
]

parser = WireParser.new
wire = parser.parse_with_debug data.last
pp wire[:line] if wire

exit
data.each_with_index do |name, index|
  wire = parser.parse name
  puts index
  pp wire[:line]
end




#puts wire[:line][:model]
exit

config = ConfigParser.new.parse(File.read("config.txt"))
#pp config
puts config[:document][0][:value][:string]
puts config[:document].class
