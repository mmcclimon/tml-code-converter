#!/usr/bin/env ruby

require 'spec_helper'
require 'tml_token_parser'

class Dummy
  include TmlTokenParser::Values
end

describe TmlTokenParser::Values do

  let(:dummy) { Dummy.new }

  describe "do_multiples" do
    it "checks for duplex" do
      mult = dummy.do_multiples('2L')
      expect(mult).to be == 2
    end

    it "checks for triplex" do
      mult = dummy.do_multiples('3L')
      expect(mult).to be == 3
    end

    it "checks for quadruplex" do
      mult = dummy.do_multiples('4L')
      expect(mult).to be == 4
    end

    it "returns 1 if no preceding number" do
      mult = dummy.do_multiples('L')
      expect(mult).to be == 1
    end
  end

  describe "#do_length" do
    it "returns duplex for 2, maxima|longa" do
      expect(dummy.do_length(2, 'longa')).to be == 'duplex'
      expect(dummy.do_length(2, 'maxima')).to be == 'duplex'
    end

    it "returns triplex for 3, maxima|longa" do
      expect(dummy.do_length(3, 'longa')).to be == 'triplex'
      expect(dummy.do_length(3, 'maxima')).to be == 'triplex'
    end

    it "returns quadruplex for 4, maxima|longa" do
      expect(dummy.do_length(4, 'longa')).to be == 'quadruplex'
      expect(dummy.do_length(4, 'maxima')).to be == 'quadruplex'
    end

    it "returns nil if len < 2 or len > 4" do
      expect(dummy.do_length(1, 'longa')).to be_nil
      expect(dummy.do_length(5, 'longa')).to be_nil
    end

    it "throws :unrecognized if note isn't a maxima or longa" do
      expect{ dummy.do_length(2, 'breve') }.to throw_symbol(:unrecognized, 'bad_length')
      expect{ dummy.do_length(2, 'semibreve') }.to throw_symbol(:unrecognized, 'bad_length')
      expect{ dummy.do_length(3, 'minima') }.to throw_symbol(:unrecognized, 'bad_length')
      expect{ dummy.do_length(4, 'fusa') }.to throw_symbol(:unrecognized, 'bad_length')
    end
  end

  describe "#do_values" do
    it "returns 'maxima' for MX" do
      expect(dummy.do_values("MX")).to be == 'maxima'
      expect(dummy.do_values("2MX")).to be == 'maxima'
      expect(dummy.do_values("4MX")).to be == 'maxima'
    end

    it "returns 'longa' for L" do
      expect(dummy.do_values("L")).to be == 'longa'
      expect(dummy.do_values("2L")).to be == 'longa'
    end

    it "returns 'brevis' for B" do
      expect(dummy.do_values("B")).to be == 'brevis'
    end

    it "returns 'semibrevis' for S" do
      expect(dummy.do_values("S")).to be == 'semibrevis'
    end

    it "returns 'minima' for M" do
      expect(dummy.do_values("M")).to be == 'minima'
    end

    it "returns 'semiminima' for SM" do
      expect(dummy.do_values("SM")).to be == 'semiminima'
    end

    it "returns 'addita' for A" do
      expect(dummy.do_values("A")).to be == 'addita'
    end

    it "returns 'fusa' for F" do
      expect(dummy.do_values("F")).to be == 'fusa'
    end

    it "throws :unrecognized if not in lookup table" do
      expect{ dummy.do_values('SB') }.to throw_symbol(:unrecognized, 'no_key')
      expect{ dummy.do_values('X') }.to throw_symbol(:unrecognized, 'no_key')
      expect{ dummy.do_values('mx') }.to throw_symbol(:unrecognized, 'no_match')
    end

  end


end
