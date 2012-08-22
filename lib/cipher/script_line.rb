require 'cipher/script'
require 'cipher/script_node'

class Cipher::Script::Line
  attr_accessor :script, :number, :indent, :content, :block, :nodes, :tree
  def initialize(script, text, number)
    @script = script
    text =~ /^(\s*)(.*)$/
    @indent = $1
    @content = $2
    @number = number
    @nodes = resolve_nodes
    @tree = nodes_to_tree
  end
  def text
    indent + content
  end
  def resolve_nodes
    Cipher::Script::Node.resolve_line(self)
  end
  def nodes_to_tree
    Cipher::Script::Node.nodes_to_tree(@nodes)
  end
  def evaluate(context)
    @tree.evaluate(context)
  end
end
