#!/usr/bin/env ruby

module TmlTokenParser
  # This module handles the common code for both Notes and Rests, and is
  # included in those classes to eliminate the duplicated functionality
  module Values

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

    @@lengths = {
      2 => 'duplex',
      3 => 'triplex',
      4 => 'quadruplex',
    }

    def do_multiples(token)
      matches = token.match(/^([234])/)
      return matches ? matches[1].to_i : 1
    end

    def do_values(token)
      matches = token.match(/^[234]?([A-Z]+)/)
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

  end
end
