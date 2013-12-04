#!/usr/bin/env ruby

module TmlTokenParser
  class NoteParser < GeneralParser

    include TmlTokenParser::Values

    @@colorations = {
      'b'  => 'nigra',
      'v'  => 'vacua',
      'r'  => 'rubea',
      'sv' => 'semivacua',
      'sr' => 'semirubea',
    }

    def parse
      args = {}   # the eventual arguments we'll send to the builder

      err = catch(:unrecognized) do
        # XXX figure out what to do with tails
        mult = do_multiples(@token)
        args['dur'] = do_values(@token)

        len = do_length(mult, args['dur'])
        args['len'] = len if len

        color = do_coloration(@token)
        args['color'] = color if color

        nil   # ensure block exits with nil if no error caught
      end

      @builder.send(:note, args) unless err
      unrecognized(@token, err) if err
    end

    private

    def do_coloration(token)
      matches = token.match(/^[A-Z]+(b|v|r|sv|sr)/)
      return nil if matches.nil?
      return @@colorations[matches[1]] if @@colorations.has_key? matches[1]
      return nil
    end

  end
end
