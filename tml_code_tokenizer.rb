#!/usr/bin/env ruby

# Main Tokenizer class, calls TmlTokenParser::Parser
# to do all of the hard work
class TmlCodeTokenizer

  # gets a Nokogiri::XML::Builder object
  def initialize(xml_builder)
    @builder = xml_builder
  end

  def parse_token(token)
    parser = TmlTokenParser::Parser.new(@builder, token)
    parser.parse
  end
end

