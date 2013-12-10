#!/usr/bin/env ruby

require 'sinatra'
require 'nokogiri'
require './lib/tml_code_tokenizer'
require './lib/tml_token_parser'

MEI_NS = 'http://www.music-encoding.org/ns/mei'
NAMESPACES = {:mei => MEI_NS}

get '/' do
  erb :index
end

get '/contact' do
  erb :contact
end

get '/convert' do
  status 403
  "You must access this page via the form on the front page"
end

post '/convert' do
  line = params[:tml_code].chomp

  builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
    tokenizer = TmlCodeTokenizer.new(xml)
    parser = TmlTokenParser::Parser.new(xml, tokenizer.tokenize(line))
    xml.section('xmlns' => MEI_NS) {
      xml.staff {
        xml.layer {
          xml.comment(" #{line} ")
          parser.parse()
        }
      }
    }
  end

  builder.to_xml
end

# this is just so that a cron job can hit this site so that the heroku
# dynos don't spin down after 30 minutes of inactivity
get '/cron.txt' do
  'ok'
end

