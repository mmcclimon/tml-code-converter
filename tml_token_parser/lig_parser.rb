#!/usr/bin/env ruby

module TmlTokenParser
  class LigParser

    def initialize(token)
      @token = token

    end

    def parse

      err = catch :unrecognized do
        notes = num_notes

        nil
      end

      # unimplemented for now, output a placeholder
      if err
        $stderr.puts "got error #{err}: #{@token}"
        return :UNRECOGNIZED, {"XXX" => @token}
      else
        return :LIGATURE, {'lig' => @token }
      end

    end

    private

    def num_notes
      matches = @token.match(/^Lig(\d+)/)
      throw :unrecognized if matches.nil?

      return matches[1]
    end

  end
end
