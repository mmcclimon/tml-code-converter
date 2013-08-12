#!/usr/bin/env ruby

module TmlTokenParser
  class MiscParser < GeneralParser

    # a bit kludgy, but this is the best I can come up with for now
    @@in_supplied = false

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

      skip_output = catch :no_output do
        sym, args = do_misc
        nil
      end

      return if skip_output || sym.nil?
      @builder.send(sym, args)

    end

    private

    # really simple for now, just match these verbatim
    def do_misc
      case
      when @@dots.has_key?(@token)
        return :dot, {'form' => 'div'}

      when @token == ']'
        @@in_supplied = false
        throw :no_output

      when @token == '['
        @@in_supplied = true
        start_supplied()
        throw :no_output

      when @@divisions.has_key?(@token)
        return :comment, "#{@@divisions[@token]} in example"

      else
        unrecognized(@token, 'no_key')
        throw :no_output
      end
    end

    def start_supplied
      @builder.supplied {
        @parent.parse_next until @@in_supplied == false
      }
    end



  end
end
