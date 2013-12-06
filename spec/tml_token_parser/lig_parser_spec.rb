#!/usr/bin/env ruby

require 'spec_helper'
require 'tml_token_parser'

describe TmlTokenParser::LigParser do

  describe "#parse" do
    it "outputs a ligature tag" do
      xml = parse("Lig4cssnod")
      expect(xpath(xml, '//ligature')).to have(1).items
    end

    it "outputs the input token as a 'lig' attribute" do
      xml = parse("Lig4cssnod")
      expect(xpath(xml, 'string(//ligature/@lig)')).to be == "Lig4cssnod"
    end

    it "outputs unrecognized if it's not a Lig token" do
      xml = parse("MXP")
      expect(xpath(xml, '//ligature')).to have(0).items
      expect(xpath(xml, '//UNRECOGNIZED')).to have(1).items
    end

    context "includes the correct number of <note> elements" do
      it "2 notes" do
        xml = parse("Lig2")
        expect(xpath(xml, '//note')).to have(2).items
      end

      it "3 notes" do
        xml = parse("Lig3cso")
        expect(xpath(xml, '//note')).to have(3).items
      end

      it "4 notes" do
        xml = parse("Lig4cssnod")
        expect(xpath(xml, '//note')).to have(4).items
      end
    end

  end
end
