#!/usr/bin/env ruby

require 'tml_token_parser'

describe TmlTokenParser::ClefParser do

  let(:builder) { Nokogiri::XML::Builder.new { |xml| xml } }

  describe "#parse" do
    it "outputs a comment tag" do
      xml = parse("ClefC3")
      expect(xpath(xml, '//comment()')).to have(1).items
      expect(xpath(xml, 'string(//comment())')).to include("clef")
    end

    it "allows a C clef" do
      xml = parse("ClefC")
      expect(xpath(xml, 'string(//comment())')).to include("C clef")
    end

    it "allows an F clef" do
      xml = parse("ClefF")
      expect(xpath(xml, 'string(//comment())')).to include("F clef")
    end

    it "allows a G clef" do
      xml = parse("ClefG")
      expect(xpath(xml, 'string(//comment())')).to include("G clef")
    end

    it "doesn't allow other clefs" do
      xml = parse("ClefZ")
      expect(xpath(xml, '//UNRECOGNIZED')).to have(1).items
    end

    it "contains the line of the clef" do
      xml = parse("ClefC4")
      expect(xpath(xml, 'string(//comment())')).to include("C clef on line 4")
    end

  end
end
