#!/usr/bin/env ruby

require 'sinatra'

get '/' do
  erb :index
end

get '/contact' do
  erb :contact
end
