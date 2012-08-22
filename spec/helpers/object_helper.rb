def new_object(value=nil)
  cipher('Object').new
end

def objectify(literal)
  case literal
  when String
    cipher('String').new literal
  when Integer
    cipher('Integer').new literal
  when Float
    cipher('Float').new literal
  else
    raise
  end
end

class JS::Object < JS::Base
  def value
    this 'value'
  end
end

class JS::String < JS::Object
  def initialize(value)
    assign_to_var("new Cipher.String(#{value.dump})")
  end
end

class JS::Numeric < JS::Object
end

class JS::Integer < JS::Numeric
  def initialize(value)
    assign_to_var("new Cipher.Integer(#{value})")
  end  
end

class JS::Float < JS::Numeric
  def initialize(value)
    assign_to_var("new Cipher.Float(#{value})")
  end  
end