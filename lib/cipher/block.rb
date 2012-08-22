class Cipher::Block
  attr_accessor :locals, :list
  
  def class_name
    'Block'
  end
  def initialize(reference_chain=nil)
    @reference_chain = reference_chain
    @locals = {}
    @list = []
  end
  def assign(local, value)
    @locals[local] = value
  end
  def retrieve(local)
    if @locals.has_key?(local)
      @locals[local]
    elsif @reference_chain
      @reference_chain.retrieve(local)
    else
      nil
    end
  end
  def concatenate_line(block)
    if @list.length == 0
      @list[0] = block.list[0]
    else
      line = block.list[0]
      @list[0].concatenate line if line
    end
    @locals.update(block.locals)
  end
  def concatenate(block)
    @list += block.list
    @locals.update(block.locals)
  end
  def append_line(line)
    @list << (line.is_a?(Line) ? line : Line.new(line))
  end
  def append_value(value)
    if @list.size == 1
      @list[0].append value
    else
      append_line Line.new(value)
    end
  end
  def update_locals(hash={})
    @locals.update(hash)
  end
  def first
    line = @list[0]
    line ? line.first : nil
  end
  class Line
    attr_accessor :values
    def class_name
      'Line'
    end
    def initialize(values=nil)
      @values = case values
      when Array
        values
      when nil
        []
      else
        [values]
      end
    end
    def concatenate(line)
      @values += line.values
    end
    def append(value)
      @values << value
    end
    def first
      @values[0]
    end
  end
end
  
