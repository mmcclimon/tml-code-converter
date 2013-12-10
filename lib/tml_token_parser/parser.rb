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
      @tokens = TmlCodeTokenizer.tokenize(line)
      @line = line
      @current_index = 0
      @num_staffs = 0
      @staff_attrs = {}
      set_next_token()
    end

    def parse
      @builder.section('xmlns' => MEI_NS) {
        @builder.comment(" #{@line} ")
          do_staffs()
      }
    end

    def get_builder
      @builder
    end

    def output_xml
      @builder.to_xml
    end

    def set_staff_attrs(key, val)
      @staff_attrs[key] = val
    end

    def tokens_left?
      @current_index <= @tokens.length
    end

    def parse_next
      t = @next_token
      set_next_token()
      t.parse
      nil
    end

    # Clients call this with the current token, which will end the current
    # <staff> element (with assoc. <staffDef>) and start a new one.
    # Throws :new_staff
    #
    # If called, that means we need to unwind the stack a bit.
    # We need to redo the current token so the clef gets processed...the throw
    # here will prevent that from happening.
    def new_staff(token)
      if @num_staffs >= 1 && @thrown_token != token
        @thrown_token = token
        # must subtract 2, since current index is the *next* token, not this one
        @current_index -= 2
        set_next_token()

        throw :new_staff, "from new_staff: #{token}"
      end
      @num_staffs += 1
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

    def do_staffs
      repeat = false
      staffDef = @builder.staffDef
      staff = @builder.staff {
        @builder.layer {
          while tokens_left?
            do_again = catch(:new_staff) { parse_next() }

            # We need to catch the :new_staff, but we actually want to finish
            # all of this processing first to make sure tags get closed
            # correctly, so we'll set a boolean here and clean up later
            if do_again
              repeat = true
              break
            end
          end
        }
      }

      # apply staff attributes if we have some
      unless @staff_attrs.empty?
        @staff_attrs.each do |k,v|
          staffDef['n'] = @num_staffs
          staff['n'] = @num_staffs
          staffDef[k] = v
        end
      end

      # Now we can process the :new_staff, since we've done the staff_attrs.
      # Clean out the staffDef attributes and go again: @current_token is now
      # the one that threw :new_staff in the first place (handled above by
      # new_staff)
      if repeat
        @staff_attrs = {}
        do_staffs()
      end

    end


  end
end
