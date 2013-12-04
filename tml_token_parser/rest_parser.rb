#!/usr/bin/env ruby

module TmlTokenParser
  class RestParser < GeneralParser

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

    def parse
      args = {}

      err = catch :unrecognized do
        # XXX figure out what to do with duplex, triplex longs, etc
        mults = do_multiples

        args['dur'] = do_values
        nil
      end

      @builder.send(:rest, args) unless err
      unrecognized(@token, err) if err

    end

    private

    def do_multiples
      matches = @token.match(/^([234]+)/)
      return matches ? matches[1] : 1
    end

    def do_values
      matches = @token.match(/^([A-Z]+P)/)
      throw :unrecognized, 'no_match' if matches.nil?

      if @@rests.has_key? matches[1]
        return @@rests[matches[1]]
      else
        throw :unrecognized, 'no_key'
      end
    end

  end
end
