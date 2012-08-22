class Cipher::Expression
  attr_accessor :line, :parent_block, :child_block
  def initialize(line, parent_block, child_block=nil)
    @line = line
    @parent_block = parent_block
    @child_block = child_block
  end
end

