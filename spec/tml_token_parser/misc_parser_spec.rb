#!/usr/bin/env ruby

require 'spec_helper'

describe TmlTokenParser::MiscParser do

  describe "#parse" do
    it "outputs <dot form='div'> element for 'pt'" do
      xml = parse("pt")
      expect(xpath(xml, '//dot[@form="div"]')).to have(1).items
    end

    it "outputs <barLine rend='single'> for ';'" do
      xml = parse(";")
      expect(xpath(xml, '//barLine[@rend="single"]')).to have(1).items
    end

    it "outputs <barLine rend='invis'> for ' '" do
      xml = parse(" ")
      expect(xpath(xml, '//barLine[@rend="invis"]')).to have(1).items
    end

    it "outputs elements wrapped in <supplied> for square brackets" do
      xml = parse_multiple(%w{[ B ]})
      expect(xpath(xml, '//supplied/note[@dur="brevis"]')).to have(1).items
    end

    it "outputs unrecognized for bogus tokens" do
      xml = parse("junk")
      expect(xpath(xml, '//UNRECOGNIZED')).to have(1).items
    end

  end

end
