#!/usr/bin/env ruby

module TmlTokenParser
  class LigParser < GeneralParser

    def parse
      args = {}
      notes = Array.new

      err = catch :unrecognized do
        num = num_notes
        num.times do
          notes << { :msg => 'note', :args => {} }
        end

        args['lig'] = @token
        nil
      end

      if err
        unrecognized(@token, err)
        return
      end

      # unimplemented for now, output a placeholder
      @builder.ligature (args) {
        notes.each do |note|
          @builder.send(note[:msg], note[:args])
        end
      }

    end

    private

    def num_notes
      matches = @token.match(/^Lig(\d+)/)
      throw :unrecognized if matches.nil?
      return matches[1].to_i
    end

  end
end
