#!/usr/bin/env ruby

require 'nokogiri'
require 'tml_code_tokenizer'

describe TmlCodeTokenizer do

  def t(str)
    TmlCodeTokenizer.tokenize(str)
  end

  describe "#tokenize" do
    it "strips leading/trailing bracket" do
      expect(t('[L]')).to be == ['L']
      expect(t('L')).to be == ['L']
    end


    it "strips leading/trailing spaces" do
      expect(t('   [L]  ')).to be == ['L']
    end

    context "token validity" do
      it "tokenizes semicolons, with optional space" do
        expect(t('L;B')).to include(';')
        expect(t('L; B')).to include('; ')
      end

      it "tokenizes 'on staffN'" do
        expect(t('L,B on staff4')).to include(' on staff4')
        expect(t('L,B;on staff4')).to include('on staff4')
      end

      it "treats commas as separators" do
        ret = t('L,B,4L')
        expect(ret).to include('L')
        expect(ret).to include('B')
        expect(ret).to include('4L')
        expect(ret).not_to include(',')
      end

      it "treats spaces as tokens" do
        expect(t('L,B B,L')).to include(' ')
      end

      it "doesn't strip non-matching brackets" do
        expect(t('[L]')).not_to include(']')
        expect(t('[L,B]')).not_to include('[')
        expect(t('L,[B]')).to include(']')
      end

      it "tokenizes brackets inside examples" do
        ret = t('L,[B]')
        expect(ret).to include('[')
        expect(ret).to include(']')
      end

      it "ignores newlines" do
        expect(t("L,B\nMX")).not_to include("\n")
      end

    end
  end
end
