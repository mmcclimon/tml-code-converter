#!/usr/bin/env ruby

module TmlTokenParser
  class ClefParser < GeneralParser

    @@clefs = {
      'ClefC' => 'C clef',
      'ClefF' => 'F clef',
      'ClefG' => 'G clef',
    }

    def parse
      args = {}

      # not sure how MEI does clefs, so return a comment for now
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

    def do_line
      matches = @token.match(/^Clef.(.*)/)
      return '' if matches.nil?
      @parent.set_staff_attrs('clef.line', matches[1])
    end

    def do_num_lines
      matches = @token.match(/\s*on staff(\d)/)
      throw :unrecognized, 'bad_staff' if matches.nil?

      num_lines = matches[1]
      @parent.set_staff_attrs('lines', num_lines)
    end
  end
end
