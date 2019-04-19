require 'rspec'
require 'parslet'
require 'parslet/rig/rspec'
require './wire_parser'

RSpec.describe WireParser  do
  let(:parser) { WireParser.new }

  context "caption_rule" do
    it "should consume 'Провод'" do
      expect(parser.caption).to parse('Провод')
    end
  end

  context "model_rule" do
    it "should consume model" do
      expect(parser.model).to parse('ПЭТД')
      expect(parser.model).to parse('ПЭТД-180')
      #expect(parser.model).to parse('ПЭТД-ХЛ')
      expect(parser.model).to parse('ПэТД')
      expect(parser.model).to parse('ПэТД-180')
    end
  end

  context "size_rule" do
    it "should consume size" do
      expect(parser.size).to parse('1x0,28')
      expect(parser.size).to parse('0,950')
      expect(parser.size).to parse('1x6')
      expect(parser.size).to parse('1x16')
      expect(parser.size).to parse('5,20х12,50/0,45')
    end
  end

  context "color_rule" do
    it "should consume color" do
      expect(parser.color).to parse('зеленый-желтый')
    end
  end

  context "tech_rule" do
    it "should consume tech" do
      expect(parser.tech).to parse('ТУ 16-705.501-2010')
      expect(parser.tech).to parse('ТУ 16-705-110-79')
      expect(parser.tech).to parse('ГОСТ')
    end
  end

  context "part1_rule" do
    it "should consume part1" do
      expect(parser.part1).to parse('ПуГВ-100 2х16')
      expect(parser.part1).to parse('ПуГВ-100 0,950')
      expect(parser.part1).to parse('ПуГВ-2 2х16')
      expect(parser.part1).to parse('ПЭТД-180 1x0,28')
      expect(parser.part1).to parse('ПЭТВ-2 0,950')
    end
  end

  context "line_rule" do
    it "should consume line" do
      expect(parser.line).to parse('ПуГВ-190 2х16 ГОСТ')
      expect(parser.line).to parse('ПЭТД-180 1x0,28')
      expect(parser.line).to parse('Провод ПЭТВ-2 0,950 ТУ 16-705-110-79')
      expect(parser.line).to parse('Провод ПуГВ 1x6, зеленый-желтый ТУ 16-705.501-2010')
    end
  end
end

RSpec::Core::Runner.run(['--format', 'documentation'])
