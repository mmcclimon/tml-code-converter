#!/usr/bin/env ruby

# Superclass for all of the individual token parsers.
module TmlTokenParser
  class GeneralParser

    # Params:
    # *+builder+::  A Nokogiri::XML::Builder object to use
    # *+token+::    The string representing this token
    def initialize(builder, token)
      @builder = builder
      @token = token
    end

    # Sets +@parent+ to the <tt>TmlTokenParser::Parser</tt> instance that
    # created this instance
    def set_parent(parent)
      @parent = parent
    end

    # Returns the raw token string
    def token_string
      @token
    end

    # The method that does all the work; overridden in subclasses
    def parse
    end

    # Outputs an <UNRECOGNIZED> tag.
    def unrecognized(token, err_string='error')
      $stderr.puts "Caught error #{err_string}: #{token}" if ENV["DEBUG"]
      @builder.UNRECOGNIZED({"XXX" => token})
    end

  end
end
