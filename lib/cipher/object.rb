require 'cipher/script'

class Cipher::Object
  attr_accessor :value, :is_literal
  def self.parse(string)
    Cipher::Literal.parse(string)
  end
  def self.find_or_create(token)
    Cipher::Literal.create(:parse=>token)
  end
  def self.resolve(string)
    token, method = self.parse(string)
    raise "Unable to parse object: #{token}" unless token
    return self.find_or_create(token), method
  end
  def initialize(args=nil)
    @value = args.is_a?(Hash) ? args[:value] : args
  end
  def evaluate(text)
    Cipher::Script::Base.new(text).run(self)
  end
end

class Cipher::Literal
  def self.matcher
    Cipher::String.matcher + '|' + Cipher::Numeric.matcher
  end
  def self.parse(method)
    if method =~ /^\s*(#{self.matcher})(\b|\.|\s*)/
      literal = $1
      remaining = $&[$1.length..-1]
      return literal, remaining.length > 0 ? remaining : nil
    else
      return nil, method
    end
  end
  def self.create(args)
    obj = (Cipher::Integer.new(args) rescue nil) ||
          (Cipher::Float.new(args) rescue nil) ||
          (Cipher::String.new(args) rescue nil)
    raise "Unable to create literal object: #{args.inspect}" unless obj
    obj.is_literal = true
    obj
  end
end

