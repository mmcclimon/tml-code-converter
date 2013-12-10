#!/usr/bin/env ruby

require 'spec_helper'

describe TmlTokenParser::MensurationParser do

  describe "#parse" do

    it "allows valid tokens" do
      expect(xpath(parse('O'), '//UNRECOGNIZED')).to have(0).items
      expect(xpath(parse('C'), '//UNRECOGNIZED')).to have(0).items
      expect(xpath(parse('CL'), '//UNRECOGNIZED')).to have(0).items
      expect(xpath(parse('CT'), '//UNRECOGNIZED')).to have(0).items
      expect(xpath(parse('CB'), '//UNRECOGNIZED')).to have(0).items
      expect(xpath(parse('R'), '//UNRECOGNIZED')).to have(0).items
      expect(xpath(parse('TR'), '//UNRECOGNIZED')).to have(0).items
    end

    it "outputs unrecognized for invalid tokens" do
      expect(xpath(parse('ZX'), '//UNRECOGNIZED')).to have(1).items
      expect(xpath(parse('GDB'), '//UNRECOGNIZED')).to have(1).items
    end

    it "outputs a <mensur> element" do
      xml = parse("C")
      expect(xpath(xml, '//mensur')).to have(1).items
    end

    it "outputs token as attribute 'mensur.sign'" do
      xml = parse("C")
      expect(xpath(xml, 'string(//mensur/@mensur.sign)')).to be == 'C'
    end

    it "outputs an label of '[token]'" do
      xml = parse("CL")
      expect(xpath(xml, 'string(//mensur/@label)')).to be == 'CL'
    end

    it "outputs multiple <mensur> elements with multiple mensurations" do
      xml = parse_multiple('C,L,B,O,L')
      expect(xpath(xml, '//mensur')).to have(2).items
    end

    context 'semicircles' do
      let(:sign_xpath) { 'string(//mensur/@mensur.sign)' }
      let(:orient_xpath) { 'string(//mensur/@mensur.orient)' }

      it "sets a 'mensur.orient = reversed' attribute for 'CL'" do
        xml = parse("CL")
        expect(xpath(xml, sign_xpath)).to be == 'C'
        expect(xpath(xml, orient_xpath)).to be == 'reversed'
      end

      it "sets a 'mensur.orient = CW' attribute for 'CB'" do
        xml = parse("CB")
        expect(xpath(xml, sign_xpath)).to be == 'C'
        expect(xpath(xml, orient_xpath)).to be == '90CW'
      end

      it "sets a 'mensur.orient = CCW' attribute for 'CT'" do
        xml = parse("CT")
        expect(xpath(xml, sign_xpath)).to be == 'C'
        expect(xpath(xml, orient_xpath)).to be == '90CCW'
      end

      it "doesn't set a 'mensur.orient' attribute for 'C'" do
        xml = parse("C")
        expect(xpath(xml, sign_xpath)).to be == 'C'
        expect(xpath(xml, '//staffDef/@mensur.orient')).to have(0).items
      end
    end

    context 'post-symbol information' do

      it "sets a 'mensur.slash = 1' for 'dim' in token" do
        xml = parse("Cdim")
        expect(xpath(xml, 'string(//mensur/@mensur.sign)')).to be == 'C'
        expect(xpath(xml, 'string(//mensur/@mensur.slash)')).to be == '1'

        xml = parse("CLdim")
        expect(xpath(xml, 'string(//mensur/@mensur.sign)')).to be == 'C'
        expect(xpath(xml, 'string(//mensur/@mensur.slash)')).to be == '1'

        xml = parse("Rdim")
        expect(xpath(xml, 'string(//mensur/@mensur.sign)')).to be == 'R'
        expect(xpath(xml, 'string(//mensur/@mensur.slash)')).to be == '1'

        xml = parse("TRdim")
        expect(xpath(xml, 'string(//mensur/@mensur.sign)')).to be == 'TR'
        expect(xpath(xml, 'string(//mensur/@mensur.slash)')).to be == '1'
      end

      it "includes 'mensur.dot' if 'd' in token" do
        xml = parse('Cd')
        expect(xpath(xml, 'string(//mensur/@mensur.sign)')).to be == 'C'
        expect(xpath(xml, 'string(//mensur/@mensur.dot)')).to be == 'true'
      end

      it "includes both 'mensur.dot' and 'mensur.slash' when necessary" do
        xml = parse('Cddim')
        expect(xpath(xml, 'string(//mensur/@mensur.sign)')).to be == 'C'
        expect(xpath(xml, 'string(//mensur/@mensur.dot)')).to be == 'true'
        expect(xpath(xml, 'string(//mensur/@mensur.slash)')).to be == '1'
      end

    end


  end
end
