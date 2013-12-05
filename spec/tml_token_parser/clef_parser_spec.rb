#!/usr/bin/env ruby

require 'nokogiri'
require 'tml_token_parser'

describe TmlTokenParser::ClefParser do

  let(:builder) { Nokogiri::XML::Builder.new { |xml| xml } }

  def parse(token)
    p = TmlTokenParser::ClefParser.new(builder, token)
    p.parse()
  end

  # check an XPath via Nokogiri::XML::XPath
  def xpath(query)
    doc = Nokogiri::XML(builder.to_xml)
    doc.xpath(query)
  end

  describe "#parse" do
    it "outputs a comment tag" do
      parse("ClefC3")
      expect(xpath('//comment()')).to have(1).items
      expect(xpath('string(//comment())')).to include("clef")
    end

    it "allows a C clef" do
      parse("ClefC")
      expect(xpath('string(//comment())')).to include("C clef")
    end

    it "allows an F clef" do
      parse("ClefF")
      expect(xpath('string(//comment())')).to include("F clef")
    end

    it "allows a G clef" do
      parse("ClefG")
      expect(xpath('string(//comment())')).to include("G clef")
    end

    it "doesn't allow other clefs" do
      parse("ClefZ")
      expect(xpath('//UNRECOGNIZED')).to have(1).items
    end

    it "contains the line of the clef" do
      parse("ClefC4")
      expect(xpath('string(//comment())')).to include("C clef on line 4")
    end

  end
end
