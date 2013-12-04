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

    @@lengths = {
      2 => 'duplex',
      3 => 'triplex',
      4 => 'quadruplex',
    }

    def parse
      args = {}

      err = catch :unrecognized do
        # XXX figure out what to do with duplex, triplex longs, etc
        mult = do_multiples
        args['dur'] = do_values

        len = do_length(mult, args['dur'])
        args['len'] = len if len

        nil
      end

      @builder.send(:rest, args) unless err
      unrecognized(@token, err) if err

    end

    private

    def do_multiples
      matches = @token.match(/^([234])/)
      return matches ? matches[1].to_i : 1
    end

    def do_values
      matches = @token.match(/^[234]?([A-Z]+P)/)
      throw :unrecognized, 'no_match' if matches.nil?

      if @@rests.has_key? matches[1]
        return @@rests[matches[1]]
      else
        throw :unrecognized, 'no_key'
      end
    end

    # check to make sure multiples are on the right note duration
    def do_length(num, dur)
      len = nil
      if 2 <= num && num <= 4
        if dur == 'maxima' || dur == 'longa'
          len = @@lengths[num]
        else
          throw :unrecognized, 'bad_length'
        end
      end
      len
    end

  end
end
