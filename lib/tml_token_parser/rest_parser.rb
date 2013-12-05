#!/usr/bin/env ruby

module TmlTokenParser
  class RestParser < GeneralParser

    include TmlTokenParser::Values

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

        nil
      end

      @builder.send(:rest, args) unless err
      unrecognized(@token, err) if err

    end

  end
end
