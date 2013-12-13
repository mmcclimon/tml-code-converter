#!/usr/bin/env ruby

require 'sinatra'
require 'nokogiri'
require './lib/tml_code_tokenizer'
require './lib/tml_token_parser'

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

# gets a POST param 'tml_code', which is passed into the parser to do all
# of the hard work
post '/convert' do
  line = params[:tml_code].chomp

  parser = TmlTokenParser::Parser.new(line)
  parser.parse()
  parser.output_xml()
end

# this is just so that a cron job can hit this site so that the heroku
# dynos don't spin down after 30 minutes of inactivity
get '/cron.txt' do
  'ok'
end

