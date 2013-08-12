#!/usr/bin/env ruby

require 'nokogiri'
require './tml_code_tokenizer'
require './tml_token_parser'

file = File.open('exx/murarspa.txt', 'r')

builder = Nokogiri::XML::Builder.new do |xml|
  tokenizer = TmlCodeTokenizer.new(xml)
  xml.root {

    example_number = 1

    file.each_line do |line|
      next if line =~ /^\s*$/
      line.chomp!
      xml.comment(" #{line} ")

      tokens = tokenizer.tokenize(line)

      xml.example("n" => example_number) {
        tokens.each { |t| tokenizer.parse_token(t) }
      }

      example_number += 1
    end


  }

end

puts builder.to_xml
