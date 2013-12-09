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

post '/convert' do
  line = params[:tml_code].chomp
  mei_ns = 'http://www.music-encoding.org/ns/mei'

  builder = Nokogiri::XML::Builder.new do |xml|
    tokenizer = TmlCodeTokenizer.new(xml)
    parser = TmlTokenParser::Parser.new(xml, tokenizer.tokenize(line))
    xml.section('xmlns' => mei_ns) {
      xml.staff {
        xml.layer {
          xml.comment(" #{line} ")
          parser.parse()
        }
      }
    }
  end

  doc = ensure_well_formed_staffs(builder)
  doc.to_xml
end

# this is just so that a cron job can hit this site so that the heroku
# dynos don't spin down after 30 minutes of inactivity
get '/cron.txt' do
  'ok'
end

# Because we're wrapping the whole thing in <section><staff><layer> tags,
# we have to fix the xml if there happen to be staff tags inside
def ensure_well_formed_staffs(builder)
  # ignore whitespace in string
  doc = Nokogiri::XML(builder.to_xml) { |config| config.default_xml.noblanks }

  # check to see if we need to rearrange, return now if we don't
  staff = doc.at_xpath('/section/staff/layer/staff')
  return doc unless staff

  # take the layer element and turn it into a section element, which becomes
  # the new document root
  layer = doc.at_xpath('/section/staff/layer')
  layer.name = 'section'
  doc.root = layer

  # wrap the contents of <staff> in <layer> tags
  staffs = doc.xpath('/section/staff')
  staffs.each do |s|
    new_layer = Nokogiri::XML::Node.new('layer', doc)
    s.children.each { |c| c.parent = new_layer }
    s.children = new_layer
  end

  doc
end
