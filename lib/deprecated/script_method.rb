require 'cipher/script'

class Cipher::Script::Method
  def self.create_if(token)
    return nil unless token.to_s =~ /\w+/
    new token
  end
  def initialize(token)
    @name = token.to_s
  end
  def evaluate(context)
    context.retrieve(@name)
  end
  def assign(value, context)
    context.assign(@name, value)
  end
end

class Cipher::Script::MethodCall
  def self.create_if(tokens)
    
  end
end