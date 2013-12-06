#!/usr/bin/env ruby

require 'spec_helper'
require 'tml_token_parser'

describe TmlTokenParser::NoteParser do

  describe "#parse" do
    it "outputs a <note> element" do
      xml = parse("MX")
      expect(xpath(xml, '//note')).to have(1).items
    end

    it "outputs the value as a 'dur' attribute" do
      xml = parse("MX")
      expect(xpath(xml, 'string(//note/@dur)')).to be == 'maxima'
    end

    # duplex, triplex, etc
    it "outputs the length as a 'len' attribute" do
      xml = parse("2L")
      expect(xpath(xml, 'string(//note/@dur)')).to be == 'longa'
      expect(xpath(xml, 'string(//note/@len)')).to be == 'duplex'
    end

    context "outputs color as 'color' attribute" do
      it "b = nigra" do
        xml = parse("Bb")
        expect(xpath(xml, 'string(//note/@color)')).to be == 'nigra'
      end

      it "v = vacua" do
        xml = parse("Bv")
        expect(xpath(xml, 'string(//note/@color)')).to be == 'vacua'
      end

      it "r = rubea" do
        xml = parse("Br")
        expect(xpath(xml, 'string(//note/@color)')).to be == 'rubea'
      end

      it "sv = semivacua" do
        xml = parse("Bsv")
        expect(xpath(xml, 'string(//note/@color)')).to be == 'semivacua'
      end

      it "sr = semirubea" do
        xml = parse("Bsr")
        expect(xpath(xml, 'string(//note/@color)')).to be == 'semirubea'
      end

      # XXX is this behavior right?
      it "omits color attribute on bogus colors" do
        xml = parse("Bsx")
        expect(xpath(xml, 'string(//note/@color)')).to be == ''
      end

    end

    it "outputs unrecognized on bogus tokens" do
      xml = parse("24X")
      expect(xpath(xml, '//UNRECOGNIZED')).to have(1).items
    end

  end

end
