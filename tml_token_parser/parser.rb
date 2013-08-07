#!/usr/bin/env ruby

module TmlTokenParser
  class Parser

    def initialize(builder, token)
      @child =  case
                when token.match(/^Lig/)
                  TmlTokenParser::LigParser.new(builder, token)
                when token.match(/^Clef/)
                  TmlTokenParser::ClefParser.new(builder, token)
                when token.match(/P/)    # only rests have a P
                  TmlTokenParser::RestParser.new(builder, token)
                when token.match(/^[OCRT]/)
                  TmlTokenParser::MensurationParser.new(builder, token)
                when token.match(/^[MLBSAF]/)
                  TmlTokenParser::NoteParser.new(builder, token)
                else
                  # MiscParser will also catch the unrecognized ones
                  TmlTokenParser::MiscParser.new(builder, token)
                end
    end

    def parse
      @child.parse
    end

  end
end
