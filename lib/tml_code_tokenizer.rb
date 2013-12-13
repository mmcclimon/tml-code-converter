#!/usr/bin/env ruby

# Tokenizer class, contains a single method 'tokenize' that splits a string
# of TML code into valid tokens
class TmlCodeTokenizer

  # param +str+ is a TML code string with optional square brackets, e.g.
  # [Lig2d,L,L,L,Bcsdx,Bcsdx,L,L,Lig2d,Lig2d]
  def self.tokenize(str)
    str = prepare_string(str)
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
  def self.prepare_string(str)
    str = str.strip
    str = str[1..-2] if str[0] == '[' && str[-1] == ']'
    str
  end
end
