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
        args['mensur.sign'] = sign
        xml_id = "staff_mens_#{sign}"
        args['xml:id'] = xml_id
        nil
      end

      if err
        unrecognized(@token, err)
        return
      end

      @builder.staffDef(args)

      # open a staff element, continue parsing until we're out of tokens
      # or the next token is another mensuration sign
      @builder.staff ({'def' => "##{xml_id}"}) {
        until @parent.tokens_left? == false ||
            @parent.next_token.class == TmlTokenParser::MensurationParser
          @parent.parse_next
        end
      }

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

  end
end
