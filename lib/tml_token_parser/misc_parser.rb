#!/usr/bin/env ruby

module TmlTokenParser
  class MiscParser < GeneralParser

    @@dots = {
      'pt' => true,
    }

    @@divisions = {
      ' ' => "space",
      ';' => "barline",
    }

    def parse
      sym = nil
      args = {}

      err = catch :unrecognized do
        sym, args = do_misc
        nil
      end

      # sym might be nil (if there's no output for this element); if it is,
      # we don't want to send any output
      @builder.send(sym, args) unless err || sym.nil?
      unrecognized(@token, err) if err
    end

    private

    # really simple for now, just match these verbatim
    def do_misc
      case
      when @@dots.has_key?(@token)
        return :dot, {'form' => 'div'}

      when @token == '['
        @builder.supplied {
          @parent.parse_next() until @parent.next_token.token_string == ']'
        }
        return nil

      when @token == ']'    # necessary so trailing bracket isn't output
        return nil

      when @token == ';'
        return :barLine, {'rend' => 'single'}

      when @token == ' '
        return :barLine, {'rend' => 'invis'}

      when @@divisions.has_key?(@token)
        return :comment, "#{@@divisions[@token]} in example"

      else
        throw :unrecognized, 'no_key'
      end

    end

  end
end