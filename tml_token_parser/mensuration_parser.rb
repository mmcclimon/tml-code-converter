#!/usr/bin/env ruby

module TmlTokenParser
  class MensurationParser < GeneralParser

    @@mensurations = {
      'O'  => 'O',
      'C'  => 'C',
      'CL' => 'semicircle open left',
      'CT' => 'semicircle open top',
      'CB' => 'semicircle open bottom',
      'R'  => 'rectangle',
      'TR' => 'triangle',
    }

    # until we figure out how MEI does mensuration, we'll put these in
    # as comments
    def parse
      args = {}

      err = catch :unrecognized do
        sign = do_mensuration
        args = " mensuration sign: #{@token} "
        nil
      end

      return err ? unrecognized(@token, err) : :comment, args
    end

    private

    def do_mensuration

    end

  end
end
