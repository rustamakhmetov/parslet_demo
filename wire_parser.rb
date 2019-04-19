# frozen_string_literal: true

require 'parslet'
require 'parslet/convenience'

# rubocop:disable Metrics/LineLength
class WireParser < Parslet::Parser
  rule(:caption) { str('Провод') }
  rule(:numbers) { match('[0-9]').repeat }
  rule(:up_letters) { match('^[А-Я]').repeat }
  rule(:small_letters) { match('[а-я]').repeat }
  rule(:whitespace) { match('[ \\t,]').repeat }

  rule(:name1) { up_letters }
  rule(:name2) { up_letters >> small_letters >> up_letters }
  rule(:name) { name2 | name1 }
  rule(:name_prefix1) { str('-') >> up_letters }
  rule(:name_prefix2) { str('-') >> numbers }

  rule(:model1) { name >> name_prefix1.maybe }
  rule(:model2) { name >> name_prefix2.maybe }
  rule(:model) { (model2 | model1).as(:model) }

  rule(:diameter) { numbers >> str(',') >> numbers | numbers }
  rule(:size_delimiter) { match('[xх]') }
  rule(:size1) { (diameter >> size_delimiter >> diameter) | diameter }
  rule(:size) { ((diameter >> match('[xх]')).maybe >> diameter >> (str('/') >> diameter).maybe).as(:size) }

  rule(:color) { (small_letters >> (str('-') >> small_letters).maybe).as(:color) }

  rule(:tu) { str('ТУ') >> whitespace >> match('[0-9\.-]').repeat.as(:tu) }
  rule(:gost) { str('ГОСТ').as(:gost) }
  rule(:tech) { tu | gost }

  rule(:part1) do
    (model >>
    whitespace.ignore >>
    size1.maybe
    ).as(:part1)
  end

  rule(:line) do
    (caption.maybe >>
      whitespace.maybe >>
        model >>
        whitespace.maybe >>
        size.maybe >>
        whitespace.maybe >>
        color.maybe >>
        whitespace.maybe >>
        tech.maybe >>
        any.repeat.maybe
    ).as(:line)
  end

  root :line
end
# rubocop:enable Metrics/LineLength
