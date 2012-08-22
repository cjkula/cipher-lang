require 'cipher/script'

class Cipher::Script::Node
  attr_accessor :line, :character_offset, :children
    
  def self.resolve_line(line)
    content = line.content
    nodes = []
    content_offset = 0
    while content_offset < content.length
      node, token_offset, chars_processed = resolve(content[content_offset..-1])
      if node
        node.line = line
        node.character_offset = content_offset + token_offset
        nodes << node
      end
      content_offset += chars_processed
    end
    nodes
  end
  
  def self.resolve(string)
    if string =~ /^\s*$/
      return nil, nil, string.length  # nothing to process; consume full string
    end
    node, offset, consumed = resolve_sequence(string, self::SymbolResolver, self::Method, self::Literal)
    raise Cipher::Script::ParsingError unless node
    return node, offset, consumed
  end
  
  def self.resolve_sequence(string, *classes)
    classes.each do |cls|
      node, offset, consumed = cls.resolve(string)
      return node, offset, consumed if node
    end
    return nil, nil, 0
  end
  
  def self.nodes_to_tree(nodes)
    if !nodes || nodes==[]
      Cipher::Script::Node::None.new
    elsif !nodes.is_a?(Array)
      nodes
    elsif nodes.length==1
      nodes[0]
    else
      build_tree(nodes)
    end
  end
  
  def self.build_tree(nodes)
    build_in_order(nodes, self::Symbol::Comma, self::Symbol::Colon) ||
          build_full_method_call(nodes) || raise(Cipher::Script::ParsingError)
  end
  
  def self.build_in_order(nodes, *classes)
    classes.each do |cls|
      indexes = class_matches(nodes, cls)
      if indexes.length > 0
        node = nodes[indexes[0]]
        node.build_tree(divide_by_indexes(nodes, indexes))
        return node
      end
    end
    nil
  end
  
  def self.build_full_method_call(nodes)
    node = nodes[0]
    case node
    when self::Method::Alphanumeric, self::Literal
      node.build_method_call(nil, nodes[1..-1])
    else
      raise Cipher::Script::ParsingError
    end
  end
  
  def build_method_call(input, nodes)
    @input_node = input
    if nodes && nodes[0]
      case nodes[0]
      when Cipher::Script::Node::Symbol::Dot
        if nodes[1].is_a? Cipher::Script::Node::Method::Alphanumeric
          return nodes[1].build_method_call(self, nodes[2..-1])
        else
          raise Cipher::Script::ParsingError  # trailing dot
        end
      when Cipher::Script::Node::Method::Symbolic
        return nodes[0].build_method_call(self, nodes[1..-1])
      else
        @param_block = Cipher::Script::Node::ParamBlock.new(nodes) if nodes.length > 0
      end
    end
    return self
  end

  def self.class_matches(nodes, cls)
    indexes = []
    nodes.each_with_index do |node, index|
      if node.is_a?(cls)
        indexes << index
        return indexes unless cls.list_separator?
      end
    end
    indexes
  end
  
  def self.divide_by_indexes(nodes, indexes)
    lists = []
    prev_index = -1
    indexes.each do |index|
      lists << nodes[prev_index+1,index-prev_index-1]
      prev_index = index
    end
    lists << nodes[prev_index+1..-1]
    lists
  end
  
  def self.list_separator?
    false
  end
    
  ######## PARAM BLOCK ########
  
  class ParamBlock
    attr_accessor :tree
    def initialize(nodes)
      @tree = Cipher::Script::Node.nodes_to_tree(nodes)
    end
    def evaluate(context=nil)
      tree.evaluate(context)
    end
  end

  ######## NONE ########
  
  class None < self
    def evaluate(context=nil)
      Cipher::Block.new
    end
  end
    
  ######## SYMBOL ########
  
  class SymbolResolver < self
    def self.resolve(string)
      cls = Cipher::Script::Node::Symbol
      resolve_sequence(string, cls::Dot, cls::Colon, cls::Comma)
    end
  end
  
  class Symbol < self
    def self.resolve(string, custom=nil)
      match = string.match(/^(\s*)#{custom || self.matcher}/)
      return nil, nil, 0 if !match
      return new, match[1].length, match[0].length
    end
    def self.matcher
      self.symbol.to_s
    end
    def build_tree(child_lists) # used by subclasses
      validate_before(child_lists)
      @children = child_lists.map { |nodes| Cipher::Script::Node.nodes_to_tree(nodes) }
      validate_after(@children)
    end
    def validate_before(child_lists)
      # override in subclasses
    end
    def validate_after(children)
      # override in subclasses
    end
    def symbol
      self.class.symbol
    end

    class Colon < self
      def self.symbol
        :':'
      end
      def evaluate(context=nil)
        raise Cipher::Script::RuntimeError unless @children[0].is_a?(Cipher::Script::Node::Method)
        right_block = @children[1].evaluate(context)  # evaluate the right side of the assignment
        first_value = right_block.first               # get the first value in the list
        block = Cipher::Block.new                     # create a new block
        return block unless first_value               # nothing to return?
        block.update_locals(right_block.locals)       # roll any local assignments up into current block
        @children[0].assign(first_value, block)       # call the method node to execute the local assignment
        block.append_value(first_value)               # add the value to this block's lines
        block
      end
    end
    class Dot < self
      def self.symbol
        :'.'
      end
      def self.resolve(string)
        node, offset, consumed = super(string.rstrip, '\.(\s|\d)?') # check for whitespace or a digit after the dot
        if consumed > 1
          if string[offset+1,1] =~ /\s/
            raise Cipher::Script::ParsingError      # no whitespace allowed before or after dot
                  # unless at the beginning or end of the line, which will be validated at the tree stage
          else
            return nil, nil, 0    # must be a digit -- dot is part of a numeric literal
          end
        end
        return node, offset, consumed
      end                                                      
    end
    class Comma < self
      def self.symbol
        :','
      end
      def self.list_separator?
        true
      end
      def evaluate(context=nil)
        block = Cipher::Block.new(context)
        children.each do |child|
          eval = child.evaluate(block)
          block.concatenate_line eval
        end
        block
      end
    end
  end
  
  ######## METHOD ########
  
  class Method < self
    attr_accessor :symbol, :input_node, :param_block
    def initialize(string)
      @symbol = string.to_sym
    end
    def self.resolve(string)
      resolve_sequence(string, self::Alphanumeric, self::Symbolic)
    end
    def self.resolve_with(string, matcher)
      match = string.match(/^(\s*)#{matcher}/)
      return nil, nil, 0 if !match
      return new(match[0].strip), match[1].length, match[0].length
    end
    def evaluate(context=nil)
      if input_node
        input = input_node.evaluate(context).first
        result = param_block ? input.send(symbol, param_block.evaluate(context).first) : input.send(symbol)
      else
        result = context.retrieve(@symbol)
        return result if result.is_a?(Cipher::Block)
      end
      block = Cipher::Block.new
      block.append_value(result) if result
      block
    end
    def assign(value, context)
      context.assign(symbol, value)
    end
    class Alphanumeric < self
      def self.resolve(string)
        self.resolve_with(string, '@?[a-zA-Z_]\\w*(\\?|\\!)?')
      end      
    end
    class Symbolic < self
      def self.resolve(string)        
        match = string.match(/^(\s*)([^\w\s\.'":]+)(\.?\d+)?/)
        return nil, nil, 0 if !match
        symbol = match[2]
        if $3 && symbol[-1..-1]=='-'
          symbol.chop!
          return nil, nil, 0 if symbol.length == 0
        end
        return new(symbol), match[1].length, match[1].length + symbol.length
      end
    end
  end
  
  ######## LITERAL ########
  
  class Literal < self
    attr_accessor :value
    
    def initialize(value)
      @value = value
    end

    def self.resolve(string)
      resolve_sequence(string, self::Numeric, self::String)
    end

    def self.resolve_with(string, matcher)
      match = string.match(/^(\s*)#{matcher}/)
      return nil, nil, 0 if !match
      value = block_given? ? yield(match[2]) : match[2]
      return new(value), match[1].length, match[0].length
    end

    def build_method_call(input, nodes)
      raise Cipher::Script::ParsingError if input
      super
    end

    class Numeric < self
      def self.resolve(string)
        resolve_sequence(string, self::Float, self::Integer)
      end
      def self.matches_unsigned?(string) # used to look ahead when an operator ending with a dash is parsed
        string =~ /^\d*\.?\d+/
      end
      class Float < self
        def self.resolve(string)
          self.resolve_with(string, '(-?\\d*\\.\\d+)\\b') { |match| match.to_f }
        end
        def evaluate(context=nil)
          block = Cipher::Block.new
          block.append_value(Cipher::Float.new(:value=>self.value))
          block
        end
      end
      class Integer < self
        def self.resolve(string)
          self.resolve_with(string, '(-?\d+)\\b') { |match| match.to_i }
        end
        def evaluate(context=nil)
          block = Cipher::Block.new
          block.append_value(Cipher::Integer.new(:value=>self.value))
          block
        end
      end
    end

    class String < self
      def self.resolve(string)
        resolve_sequence(string, SingleQuote, DoubleQuote)
      end
      def evaluate(context=nil)
        block = Cipher::Block.new
        block.append_value(Cipher::String.new(:value=>self.value))
        block
      end
      class SingleQuote < self
        def self.resolve(string)
          self.resolve_with(string, "'((\\\\'|[^'])*)'") {|match| match.gsub("\\'", "'") }
        end
      end
      class DoubleQuote < self
        def self.resolve(string)
          self.resolve_with(string, '"((\\\\"|[^"])*)"') {|match| match.gsub('\\"', '"') }
        end
      end
    end

  end
  
end
