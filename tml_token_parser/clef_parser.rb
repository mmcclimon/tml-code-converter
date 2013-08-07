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
        args = " #{do_clef}"
        args += do_line
        nil
      end

      return err ? unrecognized(@token, err) : :comment, args

    end

    private

    def do_clef
      matches = @token.match(/^(Clef[CFG])/)
      throw :unrecognized, 'no_match' if matches.nil?

      if @@clefs.has_key? matches[1]
        return @@clefs[matches[1]]
      else
        throw :unrecognized, 'no_key'
      end

    end

    def do_line
      matches = @token.match(/^Clef.(.*)/)
      return matches.nil? ? '' : " on line #{matches[1]} "
    end

  end
end
