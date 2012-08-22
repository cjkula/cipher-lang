require 'cipher/script'

class Cipher::Script::Literal
  def self.create_if(literal)
    return nil unless literal.is_a?(Cipher::Object)
    new literal
  end
  def initialize(literal)
    @literal = literal
  end
  def evaluate(context=nil)
    @literal
  end
end