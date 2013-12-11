#!/usr/bin/env ruby

require 'spec_helper'
require 'tml_token_parser'

describe TmlTokenParser::ClefParser do

  describe "#parse" do
    it "allows C, F, and G clefs" do
      xml = parse_multiple("ClefC")
      expect(xpath(xml, '//UNRECOGNIZED')).to have(0).items

      xml = parse_multiple("ClefF")
      expect(xpath(xml, '//UNRECOGNIZED')).to have(0).items

      xml = parse_multiple("ClefG")
      expect(xpath(xml, '//UNRECOGNIZED')).to have(0).items
    end

    it "doesn't allow other clefs" do
      xml = parse("ClefZ")
      expect(xpath(xml, '//UNRECOGNIZED')).to have(1).items
    end

    context "<staffDef>" do
      it "outputs a <staffDef> tag" do
        xml = parse_multiple("ClefC3")
        expect(xpath(xml, '//staffDef')).to have(1).items
      end

      it "sets attribute 'clef.shape'" do
        xml = parse_multiple("ClefC3")
        expect(xpath(xml, 'string(//staffDef/@clef.shape)')).to eq('C')

        xml = parse_multiple("ClefF3")
        expect(xpath(xml, 'string(//staffDef/@clef.shape)')).to eq('F')

        xml = parse_multiple("ClefG2")
        expect(xpath(xml, 'string(//staffDef/@clef.shape)')).to eq('G')
      end

      it "sets attribute 'clef.line'" do
        xml = parse_multiple("ClefC4")
        expect(xpath(xml, 'string(//staffDef/@clef.line)')).to eq('4')
      end

    end

    context '<staff>' do
      it "outputs a <staff> tag" do
        xml = parse_multiple("ClefC3")
        expect(xpath(xml, '//staff')).to have(1).items
      end

      it "matches the 'n' attribute on the staff/staffDef tags" do
        xml = parse_multiple("ClefC3")
        staff_def = xpath(xml, 'string(//staffDef/@n)')
        staff = xpath(xml, 'string(//staff/@n)')
        expect(staff).to eq(staff_def)
      end

      it "starts counting with n='1'" do
        xml = parse_multiple("ClefC3")
        expect(xpath(xml, 'string(//staff/@n)')).to eq('1')
      end

      it "outputs multiple staff/staffDef tags when multiple clefs" do
        xml = parse_multiple("ClefC4,ClefF3")
        expect(xpath(xml, '//staffDef')).to have(2).items
        expect(xpath(xml, '//staff')).to have(2).items

        expect(xpath(xml, '//*[@n="1"]')).to have(2).items
        expect(xpath(xml, '//*[@n="2"]')).to have(2).items
      end

    end

  end
end
