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

    context '<staffDef>'  do
      it "outputs a <staffDef> element" do
        xml = parse("C")
        expect(xpath(xml, '//staffDef')).to have(1).items
      end

      it "outputs token as attribute 'mensur.sign'" do
        xml = parse("C")
        expect(xpath(xml, 'string(//staffDef/@mensur.sign)')).to be == 'C'
      end

      it "outputs an xml:id of 'staff_mens_[token]'" do
        xml = parse("C")
        expect(xpath(xml, 'string(//staffDef/@xml:id)')).to be == 'staff_mens_C'
      end
    end

    context '<staff>' do
      it "outputs a <staff> element" do
        xml = parse("C")
        expect(xpath(xml, '//staff')).to have(1).items
      end

      it "outputs the id of the staffDef as a 'def' attribute" do
        xml = parse("C")
        expect(xpath(xml, 'string(//staff/@def)')).to be == '#staff_mens_C'
      end
    end

    context 'semicircles' do
      let(:sign_xpath) { 'string(//staffDef/@mensur.sign)' }
      let(:orient_xpath) { 'string(//staffDef/@mensur.orient)' }

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
        expect(xpath(xml, 'string(//staffDef/@mensur.sign)')).to be == 'C'
        expect(xpath(xml, 'string(//staffDef/@mensur.slash)')).to be == '1'

        xml = parse("CLdim")
        expect(xpath(xml, 'string(//staffDef/@mensur.sign)')).to be == 'C'
        expect(xpath(xml, 'string(//staffDef/@mensur.slash)')).to be == '1'

        xml = parse("Rdim")
        expect(xpath(xml, 'string(//staffDef/@mensur.sign)')).to be == 'R'
        expect(xpath(xml, 'string(//staffDef/@mensur.slash)')).to be == '1'

        xml = parse("TRdim")
        expect(xpath(xml, 'string(//staffDef/@mensur.sign)')).to be == 'TR'
        expect(xpath(xml, 'string(//staffDef/@mensur.slash)')).to be == '1'
      end

    end

    # The mensuration parser needs to deal appropriately with nested elements,
    # telling its parent to keep parsing until it finishes or there is another
    # mensuration sign.
    context 'with nested elements' do
      it "continues parsing until there are no more tokens" do
        xml = parse_multiple(['C', 'L'])
        expect(xpath(xml, '//staff/note')).to have(1).items
      end

      it "outputs multiple staffDef/staff pairs with multiple mensurations" do
        xml = parse_multiple(['C', 'L', 'B', 'O', 'L'])
        expect(xpath(xml, '//staffDef')).to have(2).items
        expect(xpath(xml, '//staff')).to have(2).items
      end

      it "nests elements appropriately with multiple mensurations" do
        xml = parse_multiple(['C', 'L', 'B', 'O', 'L'])
        expect(xpath(xml, '//staff[@def="#staff_mens_C"]/note')).to have(2).items
        expect(xpath(xml, '//staff[@def="#staff_mens_O"]/note')).to have(1).items
      end

    end


  end
end
