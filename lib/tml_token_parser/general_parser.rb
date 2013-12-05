#!/usr/bin/env ruby

module TmlTokenParser
  class GeneralParser

    def initialize(builder, token)
      @builder = builder
      @token = token
    end

    # sets +@parent+ to the <tt>TmlTokenParser::Parser</tt>
    # instance that created it
    def set_parent(parent)
      @parent = parent
    end


    # is overridden in subclasses
    def parse
    end

    def unrecognized(token, err_string='error')
      $stderr.puts "Caught error #{err_string}: #{token}"
      @builder.UNRECOGNIZED({"XXX" => token})
    end

  end
end
