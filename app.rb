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

  builder = Nokogiri::XML::Builder.new do |xml|
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

  doc = ensure_well_formed_staffs(builder)
  doc = remove_duplicate_staffDefs(doc)
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
  staff = doc.at_xpath('/mei:section/mei:staff/mei:layer/mei:staff',
                       {:mei => MEI_NS})
  return doc unless staff

  # take the layer element and turn it into a section element, which becomes
  # the new document root
  layer = doc.at_xpath('/mei:section/mei:staff/mei:layer', NAMESPACES)
  layer.name = 'section'
  doc.root = layer
  doc.root.add_namespace_definition(nil, MEI_NS)

  # wrap the contents of <staff> in <layer> tags
  staffs = doc.xpath('/mei:section/mei:staff', NAMESPACES)
  staffs.each do |s|
    new_layer = Nokogiri::XML::Node.new('layer', doc)
    s.children.each { |c| c.parent = new_layer }
    s.children = new_layer
  end

  doc
end

# Because the MensurationParser doesn't know anything about the rest of the
# document, we might wind up with duplicate <staffDef> elements. If so,
# we'll remove them here.
def remove_duplicate_staffDefs(doc)
  defs = doc.xpath('//mei:staffDef', NAMESPACES)

  seen = {}
  defs.each do |staff|
    id = staff.attributes['id'].value
    staff.remove if seen[id]
    seen[id] = true
  end

  # move them all to the top
  defs = doc.xpath('//mei:staffDef', NAMESPACES)
  prev = nil
  defs.each do |staff|
    if prev
      # we've already seen a staffDef, so add this one next
      prev.add_next_sibling(staff)
    else
      # we haven't seen one yet, so add it after the first element (which
      # is the comment containing the TML string)
      doc.root.children.first.add_next_sibling(staff)
    end
    prev = staff
  end

  doc
end
