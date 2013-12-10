#!/usr/bin/env ruby

require './lib/tml_code_tokenizer'

module TmlTokenParser
  class Parser

    MEI_NS = 'http://www.music-encoding.org/ns/mei'
    attr_reader :next_token

    # Params:
    # *+builder+:: a <tt>Nokogiri::XML::Builder</tt> instance
    # *+tokens+:: a parsed set of tokens, returned by a +TmlCodeTokenizer+
    def initialize (line)
      @builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') { |b| b }
      @line = line
      @tokens = TmlCodeTokenizer.tokenize(line)
      @current_index = 0
      set_next_token()
    end

    def parse
      @builder.section('xmlns' => MEI_NS) {
        staff = @builder.staff {
          @builder.layer {
            @builder.comment(" #{@line} ")
            parse_next() while tokens_left?
          }
        }
      }
    end

    def get_builder
      @builder
    end

    def output_xml
      @builder.to_xml
    end

    def tokens_left?
      @current_index <= @tokens.length
    end

    def parse_next
      t = @next_token
      set_next_token()
      t.parse
    end

    private

    def match_token(token)
      case
        when token.match(/^Lig/)
          TmlTokenParser::LigParser.new(@builder, token)
        when token.match(/^Clef/)
          TmlTokenParser::ClefParser.new(@builder, token)
        when token.match(/P/)    # only rests have a P
          TmlTokenParser::RestParser.new(@builder, token)
        when token.match(/^[OCRT]/)
          TmlTokenParser::MensurationParser.new(@builder, token)
        when token.match(/^[234]?[MLBSAF]/)
          TmlTokenParser::NoteParser.new(@builder, token)
        else
          # MiscParser will also catch the unrecognized ones
          TmlTokenParser::MiscParser.new(@builder, token)
      end
    end

    def set_next_token
      token = @tokens[@current_index]
      @current_index += 1
      return if token.nil?

      child = match_token(token)
      child.set_parent(self)
      @next_token = child
    end


  end
end
