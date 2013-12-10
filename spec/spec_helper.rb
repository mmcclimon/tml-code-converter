#!/usr/bin/env ruby

require 'nokogiri'
require 'tml_token_parser'

def get_builder
  Nokogiri::XML::Builder.new { |xml| xml }
end

def get_parent_stub
  obj = {}
  obj.stub(:tokens_left? => false)
  obj
end

def parse(token)
  builder = get_builder()

  # Output a root element so we're sure the XML is  well-formed
  builder.root {
    p = described_class.new(builder, token)
    p.set_parent(get_parent_stub())
    p.parse()
  }
  builder
end

# Used when needing to test nesting elements. Depens on TmlTokenParser::Parser
def parse_multiple(token_string)
  p = TmlTokenParser::Parser.new(token_string)
  p.parse()
  p.get_builder()
end

def xpath(builder, query)
  doc = Nokogiri::XML(builder.to_xml)
  doc.xpath(query)
end

