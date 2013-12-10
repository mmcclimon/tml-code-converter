#!/usr/bin/env ruby

require 'spec_helper'

def match_t(token)
  p = TmlTokenParser::Parser.new('')
  p.send(:match_token, token)
end

describe TmlTokenParser::Parser do

  # The tests here are minimal for now. Basically if it parses one thing
  # correctly it will parse any series of tokens correctly. All of theh work
  # is done in the individual classes
  describe "#parse" do
    it "parses correctly" do
      xml = parse_multiple('L,B')
      expect(xpath(xml, '//note[@dur="longa"]')).to have(1).items
      expect(xpath(xml, '//note[@dur="brevis"]')).to have(1).items
    end
  end

  # match_token is a private method, but it's the only one that really does
  # anything interesting, so we'll test it directly
  describe "#match_token" do
    it "matches ligatures to LigParser" do
      expect(match_t('Lig4css')).to be_instance_of(TmlTokenParser::LigParser)
      expect(match_t('Lig2')).to be_instance_of(TmlTokenParser::LigParser)
    end

    it "matches clefs to ClefParser" do
      expect(match_t('ClefC')).to be_instance_of(TmlTokenParser::ClefParser)
      expect(match_t('ClefF')).to be_instance_of(TmlTokenParser::ClefParser)
      expect(match_t('ClefZ')).to be_instance_of(TmlTokenParser::ClefParser)
    end

    it "matches rests to RestParser" do
      expect(match_t('MXP')).to be_instance_of(TmlTokenParser::RestParser)
      expect(match_t('LP')).to be_instance_of(TmlTokenParser::RestParser)
    end

    it "matches ^[OCRT] to MensurationParser" do
      expect(match_t('O')).to be_instance_of(TmlTokenParser::MensurationParser)
      expect(match_t('C')).to be_instance_of(TmlTokenParser::MensurationParser)
      expect(match_t('R')).to be_instance_of(TmlTokenParser::MensurationParser)
      expect(match_t('T')).to be_instance_of(TmlTokenParser::MensurationParser)
    end

    it "matches notes to NoteParser" do
      expect(match_t('MX')).to be_instance_of(TmlTokenParser::NoteParser)
      expect(match_t('2MX')).to be_instance_of(TmlTokenParser::NoteParser)
      expect(match_t('3L')).to be_instance_of(TmlTokenParser::NoteParser)
      expect(match_t('4B')).to be_instance_of(TmlTokenParser::NoteParser)
      expect(match_t('B')).to be_instance_of(TmlTokenParser::NoteParser)
      expect(match_t('F')).to be_instance_of(TmlTokenParser::NoteParser)
      expect(match_t('A')).to be_instance_of(TmlTokenParser::NoteParser)
      expect(match_t('S')).to be_instance_of(TmlTokenParser::NoteParser)
    end

    it "matches anything else to MiscParser" do
      expect(match_t('foo')).to be_instance_of(TmlTokenParser::MiscParser)
      expect(match_t(';')).to be_instance_of(TmlTokenParser::MiscParser)
      expect(match_t(',')).to be_instance_of(TmlTokenParser::MiscParser)
      expect(match_t(' ')).to be_instance_of(TmlTokenParser::MiscParser)
      expect(match_t('unknown')).to be_instance_of(TmlTokenParser::MiscParser)
    end
  end

end
