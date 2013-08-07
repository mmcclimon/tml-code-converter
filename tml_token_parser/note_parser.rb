#!/usr/bin/env ruby

module TmlTokenParser
  class NoteParser

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

    def initialize(token)
      @token = token
    end

    def parse
      args = {}   # the eventual arguments we'll send to the builder

      err = catch(:unrecognized) do
        args['dur'] = do_values

        color = do_coloration
        args['color'] = color if color

        nil   # ensure block exits with nil if no error caught
      end

      if err
        $stderr.puts "caught error #{err}: #{@token}"
        return :UNRECOGNIZED, {"XXX" => @token}
      else
        return :note, args
      end

    end

    private

    def do_values
      matches = @token.match(/^([A-Z]+)/)
      throw :unrecognized, 'no_match' if matches.nil?

      if @@notes.has_key? matches[1]
        return @@notes[matches[1]]
      else
        throw :unrecognized, 'no_key'
      end

    end

    def do_coloration
      matches = @token.match(/^[A-Z]+(b|v|r|sv|sr)/)
      return nil if matches.nil?
      return @@colorations[matches[1]] if @@colorations.has_key? matches[1]
      return nil
    end

  end
end
