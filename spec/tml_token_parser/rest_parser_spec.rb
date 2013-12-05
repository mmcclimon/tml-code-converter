#!/usr/bin/env ruby

require 'spec_helper'
require 'tml_token_parser'

describe TmlTokenParser::RestParser do

  let(:builder) { Nokogiri::XML::Builder.new { |xml| xml } }

  describe "#parse" do
    it "outputs a <rest> element" do
      xml = parse("MXP")
      expect(xpath(xml, '//rest')).to have(1).items
    end

    it "outputs the value as a 'dur' attribute" do
      xml = parse("MXP")
      expect(xpath(xml, 'string(//rest/@dur)')).to be == 'maxima'
    end

    # duplex, triplex, etc
    it "outputs the length as a 'len' attribute" do
      xml = parse("2LP")
      expect(xpath(xml, 'string(//rest/@dur)')).to be == 'longa'
      expect(xpath(xml, 'string(//rest/@len)')).to be == 'duplex'
    end

    it "outputs unrecognized on bogus tokens" do
      xml = parse("24XP")
      expect(xpath(xml, '//UNRECOGNIZED')).to have(1).items
    end

  end

end
