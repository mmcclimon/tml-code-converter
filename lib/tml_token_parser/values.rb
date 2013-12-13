#!/usr/bin/env ruby

# This module handles the common code for both Notes and Rests, and is
# included in each of those classes
module TmlTokenParser
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

    # Handles duplex/triplex/quadruplex maxima and longa tokens. Returns an
    # int between 1 and 4.
    def do_multiples(token)
      matches = token.match(/^([234])/)
      return matches ? matches[1].to_i : 1
    end

    # Handles the note/rest name (maxima, longa, brevis, etc.). Returns string
    # of note name. Throws +:unrecognized+ if this doesn't look like a note or
    # rest token.
    def do_values(token)
      matches = token.match(/^[234]?([A-Z]+)/)
      throw :unrecognized, 'no_match' if matches.nil?

      if @@notes.has_key? matches[1]
        return @@notes[matches[1]]
      else
        throw :unrecognized, 'no_key'
      end
    end

    # Check to make sure multiples are on the right note duration, throws
    # +:unrecognized+ if they aren't.
    #
    # Duplex/triplex/quadruplex are only permitted on maximas and longas, and
    # not on other note lengths.
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
