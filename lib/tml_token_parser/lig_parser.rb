#!/usr/bin/env ruby

# Parsing class for ligature elements. Ligatures are by far the most
# complicated elements in the TML code, and we're not entirely sure how to
# best output represent them in MEI. For now, this class only outputs a
# <ligature> tag with the correct number of nested <note> tags inside.
#
# MEI represents ligatures in a literate way (recta or oblique), with
# information that requires a bit of knowledge to parse. TML encodes the raw
# shape of the ligature instead, which is much easier. Mensural notation is
# hard, so we'll just let people do it by hand.
module TmlTokenParser
  class LigParser < GeneralParser

    # Parse this token into XML. <ligature><note/><note/>...</ligature>
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

    # Matches the number of notes, returns an int.
    def num_notes
      matches = @token.match(/^Lig(\d+)/)
      throw :unrecognized, 'no_match' if matches.nil?
      return matches[1].to_i
    end

  end
end
