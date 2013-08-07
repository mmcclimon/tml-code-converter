#!/usr/bin/env ruby

module TmlTokenParser
  class Parser

    def initialize(builder, token)
      @builder = builder
      @token = token
    end

    def parse
      mult_re = /^([234])/
      mults = @token.match(mult_re)
      @multiple = mults.nil? ? 1 : mults[1]
      @token.sub!(mult_re, '')

      @child =  case
                when @token.match(/^Lig/)
                  TmlTokenParser::LigParser.new(@token)
                when @token.match(/^Clef/)
                  TmlTokenParser::ClefParser.new(@token)
                when @token.match(/P/)    # only rests have a P
                  TmlTokenParser::RestParser.new(@token)
                when @token.match(/^[OCRT]/)
                  TmlTokenParser::MensurationParser.new(@token)
                when @token.match(/^[MLBSAF]/)
                  TmlTokenParser::NoteParser.new(@token)
                else
                  # MiscParser will also catch the unrecognized ones
                  TmlTokenParser::MiscParser.new(@token)
                end

      method, args = @child.parse.flatten
      @builder.send(method, args)

    end

    private

    def parse_lig
      @builder.LIGATURE("lig" => @token)
    end

    def do_multiples
      matches = @token.match(/^([234])/)
      @multiple = matches.nil? ? nil : matches[0]
    end

    def do_capitals
      caps = @token.match(/^([A-Z]+)/)
      $stderr.print "#{caps[1]} " unless caps.nil?


    end
  end

end
