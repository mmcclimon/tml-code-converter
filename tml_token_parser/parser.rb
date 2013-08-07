#!/usr/bin/env ruby

module TmlTokenParser
  class Parser

    def initialize(builder, token)
      @builder = builder
      @child =  case
                when token.match(/^Lig/)
                  TmlTokenParser::LigParser.new(token)
                when token.match(/^Clef/)
                  TmlTokenParser::ClefParser.new(token)
                when token.match(/P/)    # only rests have a P
                  TmlTokenParser::RestParser.new(token)
                when token.match(/^[OCRT]/)
                  TmlTokenParser::MensurationParser.new(token)
                when token.match(/^[MLBSAF]/)
                  TmlTokenParser::NoteParser.new(token)
                else
                  # MiscParser will also catch the unrecognized ones
                  TmlTokenParser::MiscParser.new(token)
                end
    end

    def parse

      method, args = @child.parse.flatten
      @builder.send(method, args)

    end

  end
end
