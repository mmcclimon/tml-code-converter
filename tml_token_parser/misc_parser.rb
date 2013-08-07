#!/usr/bin/env ruby

module TmlTokenParser
  class MiscParser

    @@dots = {
      'pt' => true,
    }

    @@divisions = {
      ' ' => "space",
      '[' => "left square bracket",
      ']' => "right square bracket",
    }

    def initialize(token)
      @token = token
    end

    def parse
      sym = nil
      args = {}

      err = catch :unrecognized do
        sym, args = do_misc
        nil
      end

      if err
        $stderr.puts "caught error #{err}: #{@token}"
        return :UNRECOGNIZED, {"XXX" => @token}
      else
        return sym, args
      end

    end

    private

    # really simple for now, just match these verbatim
    def do_misc
      case
      when @@dots.has_key?(@token)
        return :dot, {'form' => 'div'}
      when @@divisions.has_key?(@token)
        return :comment, "#{@@divisions[@token]} in example"
      else
        throw :unrecognized, 'no_key'
      end
    end

  end
end
