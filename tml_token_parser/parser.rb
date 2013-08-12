#!/usr/bin/env ruby

module TmlTokenParser
  class Parser

    attr_reader :next_token

    # Params:
    # *+builder+:: a <tt>Nokogiri::XML::Builder</tt> instance
    # *+tokens+:: a parsed set of tokens, returned by a +TmlCodeTokenizer+
    def initialize (builder, tokens)
      @builder = builder
      @tokens = tokens
      @current_index = 0
      set_next_token()
    end

    def parse
      parse_next() until @current_index == @tokens.length
    end

    def tokens_left?
      @current_index < @tokens.length
    end

    def parse_next
      t = @next_token
      set_next_token()
      t.parse
    end

    private

    def set_next_token
      token = @tokens[@current_index]
      @current_index += 1

      child =  case
               when token.match(/^Lig/)
                 TmlTokenParser::LigParser.new(@builder, token)
               when token.match(/^Clef/)
                 TmlTokenParser::ClefParser.new(@builder, token)
               when token.match(/P/)    # only rests have a P
                 TmlTokenParser::RestParser.new(@builder, token)
               when token.match(/^[OCRT]/)
                 TmlTokenParser::MensurationParser.new(@builder, token)
               when token.match(/^[MLBSAF]/)
                 TmlTokenParser::NoteParser.new(@builder, token)
               else
                 # MiscParser will also catch the unrecognized ones
                 TmlTokenParser::MiscParser.new(@builder, token)
               end
      child.set_parent(self)
      @next_token = child
    end


  end
end
