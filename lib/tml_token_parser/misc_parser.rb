#!/usr/bin/env ruby

# Parsing class for everything which doesn't fall anywhere else. Right now
# this means punctuation as well as 'pt' tokens.
module TmlTokenParser
  class MiscParser < GeneralParser

    @@dots = {
      'pt' => true,
    }

    # Parse this token into XML
    def parse
      err = catch :unrecognized do
        do_misc()
        nil     # ensure block returns falsy
      end

      unrecognized(@token, err) if err
    end

    private

    # Actually run the thing. Unlike most of the other classes, this sends
    # messages to the builder directly. Throws +:unrecognized+ if it doesn't
    # know how to handle this element.
    def do_misc
      case

      # 'pt' tokens => <dot form="div"/>
      when @@dots.has_key?(@token)
        @builder.send(:dot, {'form' => 'div'})

      # square brackets indicated <supplied> elements. We have to open the tag
      # and continue parsing until we see a closing square bracket
      when @token == '['
        @builder.supplied {
          @parent.parse_next() until @parent.next_token.token_string == ']'
        }
        return

      when @token == ']'    # necessary so trailing bracket is recognized
        return

      # semicolon => <barLine rend="single"/>
      when @token == ';'
        @builder.send(:barLine, {'rend' => 'single'})

      # semicolon => <barLine rend="single"/>, warn about space
      when @token == '; '
        @builder.send(:comment, " Warning: semicolon with space in example ")
        @builder.send(:barLine, {'rend' => 'single'})

      # space => <barLine rend="invis"/>
      when @token == ' '
        @builder.send(:barLine, {'rend' => 'invis'})

      else
        throw :unrecognized, 'no_key'
      end
    end

  end
end
