#!/usr/bin/env ruby

module TmlTokenParser
  class RestParser

    @@rests = {
      'MXP' => 'maxima',
      'LP'  => 'longa',   # XXX differentiate between perfect/imperfect longs
      'BP'  => 'brevis',
      'SP'  => 'semibrevis',
      'MP'  => 'minima',
      'SMP' => 'semiminima',
      'AP'  => 'addita',
      'FP'  => 'fusa',
    }

    def initialize(token)
      @token = token
    end

    def parse
      args = {}

      err = catch :unrecognized do
        args['dur'] = do_values
        nil
      end

      if err
        $stderr.puts "caught error #{err}: #{@token}"
        return :UNRECOGNIZED, {"XXX" => @token}
      else
        return :rest, args
      end

    end

    private

    def do_values
      matches = @token.match(/^([A-Z]+P)/)
      throw unrecognized, 'no_match' if matches.nil?

      if @@rests.has_key? matches[1]
        return @@rests[matches[1]]
      else
        throw :unrecognized, 'no_key'
      end
    end

  end
end
