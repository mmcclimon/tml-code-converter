#!/usr/bin/env ruby

require 'nokogiri'
require 'tml_token_parser'

MEI_NS = 'http://www.music-encoding.org/ns/mei'

def get_builder
  Nokogiri::XML::Builder.new { |xml| xml }
end

def parse(token)
  builder = get_builder()

  # Output a root element so we're sure the XML is  well-formed
  builder.root {
    p = described_class.new(builder, token)
    p.parse()
  }
  builder
end

# Used when needing to test nesting elements. Depens on TmlTokenParser::Parser
def parse_multiple(token_string)
  p = TmlTokenParser::Parser.new(token_string)
  p.parse()
  p.instance_variable_get("@builder")
end

def xpath(builder, query, ns=nil)
  doc = Nokogiri::XML(builder.to_xml)
  if ns
    doc.xpath(query, ns)
  else
    doc.remove_namespaces!
    doc.xpath(query)
  end
end

