#!/usr/bin/env ruby

# Parsing class for Note tokens
module TmlTokenParser
  class NoteParser < GeneralParser

    # Most of the functionality here is handled by the Values module.
    include TmlTokenParser::Values

    # ...except for coloration, which rests don't have.
    @@colorations = {
      'b'  => 'nigra',
      'v'  => 'vacua',
      'r'  => 'rubea',
      'sv' => 'semivacua',
      'sr' => 'semirubea',
    }

    # Parse this token into XML, <note> elements
    #
    # XXX figure out what to do with tails
    def parse
      args = {}

      err = catch(:unrecognized) do
        mult = do_multiples(@token)
        args['dur'] = do_values(@token)

        len = do_length(mult, args['dur'])
        args['len'] = len if len

        color = do_coloration(@token)
        args['color'] = color if color

        nil   # ensure block returns falsy
      end

      @builder.send(:note, args) unless err
      unrecognized(@token, err) if err
    end

    private

    # Handles note coloration, returns a string containing the correct color
    def do_coloration(token)
      matches = token.match(/^[A-Z]+(b|v|r|sv|sr)/)
      return nil if matches.nil?
      return @@colorations[matches[1]] if @@colorations.has_key? matches[1]
      return nil
    end

  end
end
