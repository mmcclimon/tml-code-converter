#!/usr/bin/env ruby

# Main Tokenizer class, calls TmlTokenParser::Parser
# to do all of the hard work
class TmlCodeTokenizer

  # gets a Nokogiri::XML::Builder object
  def initialize(xml_builder)
    @builder = xml_builder
  end

  # param +str+ is a TML code string in square brackets, e.g.
  # [Lig2d,L,L,L,Bcsdx,Bcsdx,L,L,Lig2d,Lig2d]
  def tokenize(str)
    str.sub!(/^\[/, '').sub!(/\]$/, '')  # strip leading/trailing bracket

    # split into tokens
    tokens = str.split(/(;\ ?|                  # semicolon, with optional space
                         \ ?on\ staff\d\ ?|     # on staffX, optional spaces
                         ,|                     # comma
                         \ |                    # space alone
                         \[|                    # left bracket [
                         \]|                    # right bracket ]
                         \n)                    # newline
                       /x)
    tokens.reject! { |t| t == ',' || t == '' || t == "\n" }
    tokens.map! { |t| t == '; ' ? ';' : t }

    return tokens
  end

  def parse_token(token)
    parser = TmlTokenParser::Parser.new(@builder, token)
    parser.parse
  end
end
