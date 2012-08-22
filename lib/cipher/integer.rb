require 'cipher/numeric'

class Cipher::Integer < Cipher::Numeric
  def self.matcher
    '-?\d+'
  end
  def initialize(args)
    if args.is_a?(Hash) && args[:parse]
      @value = Integer(args[:parse])
    else
      super
    end
  end
  def +(number)
    case number
    when Cipher::Float
      Cipher::Float.new :value => (value + number.value)
    when Cipher::Integer
      Cipher::Integer.new :value => (value + number.value)
    else
      raise Cipher::Script::RuntimeError
    end
  end
end
