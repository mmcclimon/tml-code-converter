#!/usr/bin/env ruby

module TmlTokenParser
  class MensurationParser

    @@mensurations = {
      'O'  => 'O',
      'C'  => 'C',
      'CL' => 'semicircle open left',
      'CT' => 'semicircle open top',
      'CB' => 'semicircle open bottom',
      'R'  => 'rectangle',
      'TR' => 'triangle',
    }

    def initialize(token)
      @token = token
    end

    # until we figure out how MEI does mensuration, we'll put these in
    # as comments
    def parse
      args = {}

      err = catch :unrecognized do
        sign = do_mensuration

        nil
      end

      if err
        $stderr.puts "caught error #{err}: #{@token}"
        return :UNRECOGNIZED, {"XXX" => @token}
      else
        return :comment, " mensuration sign: #{@token} "
      end

    end

    private

    def do_mensuration

    end

  end
end
