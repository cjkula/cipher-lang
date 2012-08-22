require 'cipher/script'

class Cipher::Script::Operation
  def initialize(left_tokens, right_tokens)
    @left = Cipher::Script::Operation.tree_from_tokens(left_tokens)
    @operation = self.class.symbol
    @right = Cipher::Script::Operation.tree_from_tokens(right_tokens)
  end
  def symbol
    nil # override in subclasses
  end
  def self.tree_from_tokens(tokens)
    return tokens unless tokens.is_a?(Array)
    return Cipher::Script::Operation::None.new if tokens.length == 0
    tree = Cipher::Script::Operation::Colon.tree_if_found(tokens) ||
           Cipher::Script::Operation::Comma.tree_if_found(tokens) ||
           Cipher::Script::MethodCall.create_if(tokens)
    return tree if tree
    if tokens.length == 1
      token = tokens[0]
      leaf = Cipher::Script::Literal.create_if(token)
      return leaf if leaf
    end
    raise Cipher::Script::ParsingError
  end
  # def self.tree_from_tokens(tokens)
  #   return tokens unless tokens.is_a?(Array)
  #   return Cipher::Script::Operation::None.new if tokens.length == 0
  #   tree = Cipher::Script::Operation::Colon.tree_if_found(tokens) ||
  #          Cipher::Script::Operation::Comma.tree_if_found(tokens) ||
  #          Cipher::Script::MethodCall.create_if(tokens)
  #   return tree if tree
  #   if tokens.length == 1
  #     token = tokens[0]
  #     leaf = Cipher::Script::Literal.create_if(token)
  #     return leaf if leaf
  #   end
  #   raise Cipher::Script::ParsingError
  # end
  def self.tree_if_found(tokens) # used by subclasses
    index = tokens.index(self.symbol)
    return nil unless index
    left_tokens = tokens[0,index]
    right_tokens = tokens[(index+1)..-1]
    validate_before(left_tokens, right_tokens)
    left_tree = Cipher::Script::Operation.tree_from_tokens(left_tokens)
    right_tree = Cipher::Script::Operation.tree_from_tokens(right_tokens)
    validate_after(left_tree, right_tree)
    self.new(left_tree, right_tree)
  end
  def self.validate_before(left_tokens, right_tokens)
    # override in subclasses
  end
  def self.validate_after(left_tree, right_tree)
    # override in subclasses
  end
  def evaluate(context)
    self.class.symbol
  end
end

class Cipher::Script::Operation::None
  def initialize
  end
  def evaluate
    nil
  end
end

class Cipher::Script::Operation::Colon < Cipher::Script::Operation
  def self.symbol
    :':'
  end
  def evaluate(context)
    raise Cipher::Script::ParsingError unless @left.is_a?(Cipher::Script::Method)
    result = @right.evaluate(context)
    @left.assign(result, context)
    result
  end
end

class Cipher::Script::Operation::Comma < Cipher::Script::Operation
  def self.symbol
    :':'
  end
end