#!/usr/bin/env ruby

require 'nokogiri'

def parse(token)
  # builder needs to be a Nokogiri::XML::Builder object that is let() in
  # the spec itself
  p = described_class.new(builder, token)
  p.parse()
  builder
end


def xpath(builder, query)
  doc = Nokogiri::XML(builder.to_xml)
  doc.xpath(query)
end
