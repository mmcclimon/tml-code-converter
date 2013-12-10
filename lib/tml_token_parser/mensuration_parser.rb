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
      xml_id = ''

      err = catch :unrecognized do
        sign = do_mensuration
        do_post!(args)

        # MEI handles the semicircles with an 'orient' attribute, do those here
        if sign.match(/C[LTB]/)
          args['mensur.sign'] = 'C'
          args['mensur.orient'] = do_orientation(sign)
        else
          args['mensur.sign'] = sign
        end

        args['label'] = @token
        nil
      end

      if err
        unrecognized(@token, err)
        return
      end

      @builder.mensur(args)

    end

    private

    def do_mensuration
      matches = @token.match(/^([A-Z]+)/)
      throw :unrecognized, 'no_match' if matches.nil?

      if @@mensurations.has_key? matches[1]
        return matches[1]
      else
        throw :unrecognized, "no_key"
      end
    end

    # NB: this modifies args in place to avoid a bunch of ifs in the main
    # parse() body. It's not complete yet.
    def do_post!(args)
      match = @token.match(/^[A-Z]+                         # handled by sign
                             (?<marks>d|rvd|rvs|rhdx|rhsn)?   # internal marks
                             (?<dim>dim)?                     # line of diminution
                             (?<nums>\d+)?$/x)                # trailing numbers
      return nil if match.nil?

      args['mensur.slash'] = 1 if match[:dim]
      args['mensur.dot'] = 'true' if match[:marks] == 'd'
      args
    end

    def do_orientation(sign)
      case sign
        when 'CL' then 'reversed'
        when 'CT' then '90CCW'
        when 'CB' then '90CW'
      end
    end

  end
end
