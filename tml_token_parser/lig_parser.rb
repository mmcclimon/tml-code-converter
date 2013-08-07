#!/usr/bin/env ruby

module TmlTokenParser
  class LigParser < GeneralParser

    def parse
      args = {}

      err = catch :unrecognized do
        notes = num_notes
        args['lig'] = @token
        nil
      end

      # unimplemented for now, output a placeholder
      @builder.send(:LIGATURE, args) unless err
      unrecognized(@token, err) if err

    end

    private

    def num_notes
      matches = @token.match(/^Lig(\d+)/)
      throw :unrecognized if matches.nil?

      return matches[1]
    end

  end
end
