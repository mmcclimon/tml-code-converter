#!/usr/bin/env ruby

# Main Tokenizer class, calls TmlTokenParser::Parser
# to do all of the hard work
class TmlCodeTokenizer

  # gets a Nokogiri::XML::Builder object
  def initialize(xml_builder)
    @builder = xml_builder
  end

  # param +str+ is a TML code string with optional square brackets, e.g.
  # [Lig2d,L,L,L,Bcsdx,Bcsdx,L,L,Lig2d,Lig2d]
  def tokenize(str)
    str = prepare_string(str)
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
    return tokens
  end

  private

  # strip spaces, along with matching leading/trailing square brackets
  def prepare_string(str)
    str = str.strip
    str = str[1..-2] if str[0] == '[' && str[-1] == ']'
    str
  end
end
