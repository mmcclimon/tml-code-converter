#!/usr/bin/env ruby

module TmlTokenParser
  class NoteParser < GeneralParser

    @@notes = {
      'MX' => 'maxima',
      'L' => 'longa',
      'B' => 'brevis',
      'S' => 'semibrevis',
      'M' => 'minima',
      'SM' => 'semiminima',
      'A' => 'addita',
      'F' => 'fusa',
    }

    @@colorations = {
      'b'  => 'nigra',
      'v'  => 'vacua',
      'r'  => 'rubea',
      'sv' => 'semivacua',
      'sr' => 'semirubea',
    }

    @@lengths = {
      2 => 'duplex',
      3 => 'triplex',
      4 => 'quadruplex',
    }

    def parse
      args = {}   # the eventual arguments we'll send to the builder

      err = catch(:unrecognized) do
        # XXX figure out what to do with tails
        mult = do_multiples
        args['dur'] = do_values

        len = do_length(mult, args['dur'])
        args['len'] = len if len


        color = do_coloration
        args['color'] = color if color

        nil   # ensure block exits with nil if no error caught
      end

      @builder.send(:note, args) unless err
      unrecognized(@token, err) if err
    end

    private

    def do_multiples
      matches = @token.match(/^([234])/)
      return matches ? matches[1].to_i : 1
    end

    def do_values
      matches = @token.match(/^[234]?([A-Z]+)/)
      throw :unrecognized, 'no_match' if matches.nil?

      if @@notes.has_key? matches[1]
        return @@notes[matches[1]]
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

    def do_coloration
      matches = @token.match(/^[A-Z]+(b|v|r|sv|sr)/)
      return nil if matches.nil?
      return @@colorations[matches[1]] if @@colorations.has_key? matches[1]
      return nil
    end

  end
end
