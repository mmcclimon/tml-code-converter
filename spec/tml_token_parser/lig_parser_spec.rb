#!/usr/bin/env ruby

require 'nokogiri'
require 'tml_token_parser'

describe TmlTokenParser::LigParser do

  let(:builder) { Nokogiri::XML::Builder.new { |xml| xml } }

  def parse(token)
    p = TmlTokenParser::LigParser.new(builder, token)
    p.parse()
  end

  # check an XPath via Nokogiri::XML::XPath
  def xpath(query)
    doc = Nokogiri::XML(builder.to_xml)
    doc.xpath(query)
  end

  describe "#parse" do
    it "outputs a ligature tag" do
      parse("Lig4cssnod")
      expect(xpath('//ligature')).to have(1).items
    end

    it "outputs the input token as a 'lig' attribute" do
      parse("Lig4cssnod")
      expect(xpath('string(//ligature/@lig)')).to be == "Lig4cssnod"
    end

    it "outputs unrecognized if it's not a Lig token" do
      parse("MXP")
      expect(xpath('//ligature')).to have(0).items
      expect(xpath('//UNRECOGNIZED')).to have(1).items
    end

    context "includes the correct number of <note> elements" do
      it "2 notes" do
        parse("Lig2")
        expect(xpath('//note')).to have(2).items
      end

      it "3 notes" do
        parse("Lig3cso")
        expect(xpath('//note')).to have(3).items
      end

      it "4 notes" do
        parse("Lig4cssnod")
        expect(xpath('//note')).to have(4).items
      end
    end

  end
end
