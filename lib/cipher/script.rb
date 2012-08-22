class Cipher::Script
  
  class Cipher::Script::Block

    attr_accessor :lines, :indent, :script, :context
    def initialize(script_lines, script=nil)
      @lines = script_lines
      @indent = get_indent
      @script = script || self
      create_contained_blocks
    end
    def content_lines
      @lines.find_all { |line| line.content.length > 0 }
    end
    def root_line_numbers
      content_lines.find_all { |line| line.indent == self.indent }.map { |line| line.number }
    end
    def root_lines
      root_line_numbers.map {|num| script.lines[num] }
    end
    def create_contained_blocks
      line_numbers = root_line_numbers
      line_numbers.each_with_index do |line_num, index|           # for each root level block line
        block_start = line_num + 1                                # calculate the start line number of possible child block
        next_line_num = line_numbers[index + 1] ||                # get line number of next root level expression
                        lines[-1].number + 1                      # or: next line number following end of current block
        block_end = next_line_num - 1                             # and subtract 1 for end of child block
        block_lines = script.lines[block_start..block_end]        # pass those lines (if any)
        block = block_lines.length > 0 ? Cipher::Script::Block.new(block_lines, script) : nil  # to the block constructor
        script.lines[line_num].block = block
        # @block_lines << Cipher::Expression.new(script.lines[line_num], self, block) # add expression to current block
      end
      true
    end
    def get_indent
      @lines.each do |line|
        return line.indent if line.content.length > 0
      end
      nil
    end
    def validate_indentation
      content_lines.each do |line|
        if line.indent[0, self.indent.size] != indent
          raise Cipher::Script::MismatchedIndentation, "Inconsistent indentation at line #{line.number}."
        end
      end
    end
  end

end
