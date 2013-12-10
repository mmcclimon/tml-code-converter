#!/usr/bin/env ruby

module TmlTokenParser
  class MiscParser < GeneralParser

    @@dots = {
      'pt' => true,
    }

    def parse
      sym = nil
      args = {}

      err = catch :unrecognized do
        do_misc()
        nil
      end

      # sym might be nil (if there's no output for this element); if it is,
      # we don't want to send any output
      unrecognized(@token, err) if err
    end

    private

    # really simple for now, just match these verbatim
    def do_misc
      case
      when @@dots.has_key?(@token)
        @builder.send(:dot, {'form' => 'div'})

      when @token == '['
        @builder.supplied {
          @parent.parse_next() until @parent.next_token.token_string == ']'
        }
        return nil

      when @token == ']'    # necessary so trailing bracket isn't output
        return nil

      when @token == ';'
        @builder.send(:barLine, {'rend' => 'single'})

      when @token == '; '
        @builder.send(:comment, " Warning: semicolon with space in example ")
        @builder.send(:barLine, {'rend' => 'single'})

      when @token == ' '
        @builder.send(:barLine, {'rend' => 'invis'})

      when @token.match(/\s*on staff(\d)/)
        @builder.comment(" on #{$1}-line staff ")

      else
        throw :unrecognized, 'no_key'
      end

    end

  end
end
