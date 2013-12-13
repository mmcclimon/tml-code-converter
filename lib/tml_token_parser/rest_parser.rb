#!/usr/bin/env ruby

# Parsing class for Rest tokens
module TmlTokenParser
  class RestParser < GeneralParser

    # Most of the functionality here is handled by the Values module
    include TmlTokenParser::Values

    # Parse this token into XML, <rest> elements.
    def parse
      args = {}

      # if we're in the RestParser, we know that the token has a trailing
      # 'P', so we can strip it off and treat these like notes
      t = @token.sub(/P$/, '')

      err = catch :unrecognized do
        mult = do_multiples(t)
        args['dur'] = do_values(t)

        len = do_length(mult, args['dur'])
        args['len'] = len if len

        nil       # ensure block returns falsy
      end

      @builder.send(:rest, args) unless err
      unrecognized(@token, err) if err

    end

  end
end
