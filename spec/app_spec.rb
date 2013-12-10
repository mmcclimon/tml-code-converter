#!/usr/bin/env ruby

require 'spec_helper'
require 'rack/test'
require File.expand_path '../../app.rb', __FILE__

def find_css(resp, selector)
  doc = Nokogiri::HTML(resp.body)
  doc.css(selector)
end

def find_xpath(resp, selector, ns=nil)
  doc = Nokogiri::XML(resp.body)
  if ns
    doc.xpath(selector, ns)
  else
    doc.remove_namespaces!
    doc.xpath(selector)
  end
end


describe "app" do

  include Rack::Test::Methods
  def app() Sinatra::Application end

  let(:mei_ns) { 'http://www.music-encoding.org/ns/mei' }


  describe "GET /" do
    before(:all) { get '/' }

    it "returns an HTML page" do
      expect(last_response).to be_ok
    end

    it "contains a form for entering TML code" do
      e = find_css(last_response, 'textarea#tmlCode')
      expect(e).to have(1).items
    end

    it "contains a panel for displaying MEI output" do
      e = find_css(last_response, 'div#meiDisplay')
      expect(e).to have(1).items
    end
  end

  describe "GET /contact" do
    before(:all) { get '/contact' }

    it "displays a contact page" do
      get '/contact'
      expect(last_response).to be_ok
      expect(last_response.body).to match(/CHMTL/)

      h1 = find_css(last_response, 'h1')
      expect(h1.inner_text).to be == 'Contact'
    end
  end

  describe "GET /convert" do
    before(:all) { get '/convert' }

    it "denies access" do
      get '/convert'
      expect(last_response.status).to be == 403
    end

    it "displays a useful message" do
      get '/convert'
      expect(last_response.status).to be == 403
      expect(last_response.body).to match(/must access/)
    end
  end

  describe "POST /convert" do
    before(:all) do
      post '/convert', { :tml_code => '[B]' }
    end

    it "returns a well-formed XML document" do
      expect {
        doc = Nokogiri::XML(last_response.body) { |c| c.strict }
      }.not_to raise_error
    end

    it "wraps contents in <section><staff><layer> tags" do
      res = find_xpath(last_response, '/mei:section/mei:staff/mei:layer',
                       {:mei => mei_ns})
      expect(res).to have(1).items
    end

    it "has the MEI namespace on the <section> tag" do
      res = find_xpath(last_response, '/mei:section', {:mei => mei_ns})
      expect(res).to have(1).items
    end

    it "contains a comment with the original token" do
      res = find_xpath(last_response, 'string(//comment())')
      expect(res.strip).to be == '[B]'
    end

    # ensure that the output still has the right structure
    # <section><staff><layer>, even if the example itself contains
    # <staff> elements
    context "nested staffs" do
      before(:each) { post '/convert', {:tml_code => '[C,L,B,B]'} }

      it "rearranges <staff> tags with nested staffs" do
        res = find_xpath(last_response, '/mei:section/mei:staff/mei:layer',
                         {:mei => mei_ns})
        expect(res).to have(1).items
      end

      it "doesn't add extraneous staffs" do
        res = find_xpath(last_response, '/mei:section/mei:staff/mei:layer/mei:staff',
                         {:mei => mei_ns})
        expect(res).to have(0).items
      end

      it "keeps the MEI namespace on the <section> tag" do
        mei_ns = 'http://www.music-encoding.org/ns/mei'
        res = find_xpath(last_response, '/mei:section', 'mei' => mei_ns)
        expect(res).to have(1).items
      end
    end

  end

end
