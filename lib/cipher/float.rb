require 'cipher/numeric'

class Cipher::Float < Cipher::Numeric
  def initialize(args)
    if args.is_a?(Hash) && args[:parse]
      @value = Float(args[:parse])
    else
      super
    end
  end
  def + (number)
    self.class.new :value => (value + number.value)
  end
end
