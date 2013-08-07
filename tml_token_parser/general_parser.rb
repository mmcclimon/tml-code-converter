#!/usr/bin/env ruby

module TmlTokenParser
  class GeneralParser

    def initialize(token)
      @token = token
    end

    def unrecognized(token, err_string='error')
      $stderr.puts "Caught error #{err_string}: #{token}"
      return :UNRECOGNIZED, {"XXX" => token}
    end

  end
end
