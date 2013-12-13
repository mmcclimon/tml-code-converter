#!/usr/bin/env ruby

# Parsing class for clef tokens. These are a bit trickier since in MEI clef
# information is actually encoded in <staffDef> and <staff> tags.
module TmlTokenParser
  class ClefParser < GeneralParser

    @@clefs = {
      'ClefC' => 'C clef',
      'ClefF' => 'F clef',
      'ClefG' => 'G clef',
    }

    # Parse this token into XML. Sets staff attributes on <staffDef> elements
    # and calls TmlTokenParser::Parser.new_staff() with every recogznied
    # token.
    def parse
      args = {}

      err = catch :unrecognized do
        if @token.match(/staff/)
          args = do_num_lines
          return
        else
          args = " #{do_clef} "
          args += do_line
        end
        nil
      end

      @builder.send(:comment, args) unless err
      unrecognized(@token, err) if err
    end

    private

    # Parses the clef shape and sets staff attribute clef.shape. Calls
    # @parent.new_staff to let the main parser know that it should start
    # another staff if necessary. Throws +:unrecognized+ if it doesn't look
    # like a proper clef.
    def do_clef
      matches = @token.match(/^(Clef([CFG]))/)
      throw :unrecognized, 'no_match' if matches.nil?

      @parent.new_staff(@token)

      if @@clefs.has_key? matches[1]
        @parent.set_staff_attrs('clef.shape', matches[2])
        return @@clefs[matches[1]]
      else
        throw :unrecognized, 'no_key'
      end

    end

    # Parses which line the clef sits on and sets staff attribute clef.line.
    def do_line
      matches = @token.match(/^Clef.(.*)/)
      return '' if matches.nil?
      @parent.set_staff_attrs('clef.line', matches[1])
    end

    # 'on staff4' in TML Code actually means 'on a 4-line staff', so this
    # method updates the 'lines' attribute on the relevant staffDef
    def do_num_lines
      matches = @token.match(/\s*on staff(\d)/)
      throw :unrecognized, 'bad_staff' if matches.nil?

      num_lines = matches[1]
      @parent.set_staff_attrs('lines', num_lines)
    end
  end
end
