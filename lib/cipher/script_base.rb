require 'cipher/script'

class Cipher::Script::Base < Cipher::Script::Block
  attr_accessor :text
  def initialize(text)
    @text = text
    lines = []
    text.split(/^/).each_with_index do |line, index|
      lines << Cipher::Script::Line.new(self, line.chomp.chomp, index)
    end
    super(lines, self)
  end
  def run(calling_context)
    block = Cipher::Block.new(calling_context)
    root_lines.each do |line|
      block.append line.evaluate(block)
    end
    block
  end
  def match_literal_rgx
    @match_literal_rgx ||= /^\s*(#{Cipher::Literal.matcher})/
  end
  def match_literal(string)
    string =~ match_literal_rgx ? $& : nil
  end
  def match_symbol(string)
    match_dot(string) || match_method(string) || match_operator(string)
  end
  def match_dot(string)
    if string.rstrip =~ /^\s*\.\s*/ # rstrip removes end-of-line trailing whitespace, which is syntactically irrelevant
      raise Cipher::Script::ParsingError if $&.length > 1   # no whitespace allowed before or after dot
      return '.'                                            # must be just a dot
    end
    nil                                                     # or not
  end
  def match_method(string)
    string =~ /^\s*\w+[!\?]?/ ? $& : nil
  end
  def match_operator(string)
    string =~ /^\s*([!\?\[\]\{\}\(\)\|]|[^\w\s\.'"!\?\[\]\{\}\(\)\|]+)/ ? $& : nil
  end
  def resolve_one_token(string)
    match = match_literal(string)
    if match
      token = Cipher::Object.find_or_create(match.strip)  # create object for literal
    else
      match = match_symbol(string)
      raise Cipher::Script::ParsingError unless match
      token = match.strip.to_sym                          # convert method/operator/token into symbol
    end
    return token, string[match.length..-1]                # return token and rest of string
  end
  def resolve_tokens(line)
    tokens = []
    remaining = line.content.rstrip
    while remaining.length > 0
      token, remaining = resolve_one_token(remaining)
      if token.to_s[-1,1]=='-' && remaining =~ /^\d*.?\d+/ # apply negative sign to a following numeric literal
        token = token.to_s.chop.to_sym
        remaining = '-' + remaining
      end
      tokens << token if token.to_s.length > 0
    end
    tokens
  end
end
