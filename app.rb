#!/usr/bin/env ruby

require 'sinatra'
require 'nokogiri'
require './tml_code_tokenizer'
require './tml_token_parser'

get '/' do
  erb :index
end

get '/contact' do
  erb :contact
end

get '/convert' do
  "You must access this page via the form on the front page"
end

post '/convert' do
  line = params[:tml_code]

  builder = Nokogiri::XML::Builder.new do |xml|
    tokenizer = TmlCodeTokenizer.new(xml)
    parser = TmlTokenParser::Parser.new(xml, tokenizer.tokenize(line))
    xml.example {
      xml.comment(" #{line} ")
      parser.parse()
    }
  end

  builder.to_xml
end

# this is just so that a cron job can hit this site so that the heroku
# dynos don't spin down after 30 minutes of inactivity
get '/cron.txt' do
  'ok'
end
