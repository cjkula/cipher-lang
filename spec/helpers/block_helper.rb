def new_block(locals={}, parent=nil, *lines)
  block = cipher('Block').new(parent)
  if locals
    locals.each_pair do |key, value|
      block.assign(key, objectify(value))
    end
  end
  lines.each do |line|
    block.append_line new_block_line(line)
  end
  block
end

def new_block_line(values=[])
  block = cipher('Block', 'Line').new(values.map{ |val| objectify(val) })
end

class JS::Block < JS::Base
  def initialize(parent=nil)
    assign_to_var("new Cipher.Block(#{parent})")
  end
  def append_value(object)
    this "appendValue(#{object})"
  end
  def append_line(line)
    this "appendLine(#{line})"
  end
end

class JS::Block::Line < JS::Base
  def initialize(values=[])
    obj_vars = values.map{|v| v.to_s}
    assign_to_var("new Cipher.Block.Line([#{obj_vars.join(',')}])")
  end
  def append(object_var)
    this "append(#{object_var})"
  end
  def first
    this "first()" ## problem: getting the reference variable name back from the object
    ## solution: an overhaul -- place all js test objects in window.test_objects with numeric ids
    ## that are also stored (during testing) in the objects themselves.
  end
end