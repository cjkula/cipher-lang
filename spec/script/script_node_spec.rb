require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

def test_script_line_node_symbols_and_values(text, *match_values)
  script = new_script('')
  Cipher::Script::Node.stub(:nodes_to_tree) # stop it from executing tree evaluation
  line = cipher('Script','Line').new(script, text, 1)
  nodes = line.nodes
  # nodes.each do |node|
  #   begin
  #     puts "{#{node.symbol.inspect}}"
  #   rescue
  #     puts "<#{node.value}>"
  #   end
  # end
  nodes.size.should == match_values.size
  nodes.each_with_index do |node, index|
    match_value = match_values[index]
    if node.is_a?(cipher('Script','Node','Literal'))
      node.value.should == match_value
    else
      node.symbol.to_sym.should == match_value
    end
  end
end

describe "Script::Line#resolve_nodes" do
  it "should create no lines for an empty script" do
    new_script("").lines.should == []
  end
  it "should create no lines for a script with only whitespace" # do
  #   new_script(" \n \n \n").lines.should == []
  # end
  it "should create a single node for a literal" do
    ['0.789'].each do |literal|
      lines = new_script(literal).lines
      lines.length.should == 1
      lines[0].nodes.length.should == 1
    end
  end
  it "should parse integer literals" do
    test_script_line_node_symbols_and_values '1', 1
    test_script_line_node_symbols_and_values '10 20 30', 10, 20, 30
    test_script_line_node_symbols_and_values '-5 -12 -345', -5, -12, -345
  end
  it "should parse floating point literals" do
    test_script_line_node_symbols_and_values '123.456', 123.456
    test_script_line_node_symbols_and_values '-.45 0.56 -1414.1 .321 -0.989898', -0.45, 0.56, -1414.1, 0.321, -0.989898
  end
  it "should parse single quote strings" do
    test_script_line_node_symbols_and_values "'a string for me'", 'a string for me'
    test_script_line_node_symbols_and_values "'\\\'single\\\' \"double\"'", '\'single\' "double"'
  end
  it "should parse double quote strings" do
    test_script_line_node_symbols_and_values '"a string for you"', 'a string for you'
  end
  it "should parse mixed strings in the same line" do
    test_script_line_node_symbols_and_values '"this" \'that\'', 'this', 'that'
    test_script_line_node_symbols_and_values '\'first\'  "second"', 'first', 'second'
  end
  it "should parse mixed literals in the same line" do
    test_script_line_node_symbols_and_values '"string" 12 -45 \' single \' .14', "string", 12, -45, ' single ', 0.14
  end
  it "should parse a dot at the beginning of a line" do
    test_script_line_node_symbols_and_values ".", :'.'
  end
  it "should parse a dot in the middle of a line with no whitespace before or after" do
    test_script_line_node_symbols_and_values "'bob'.'bob'", 'bob', :'.', 'bob'
  end
  it "should not parse a dot with space around it in the middle of a string" do
    lambda {
      test_script_line_node_symbols_and_values "1 . 5"
    }.should raise_error
  end
  it "should not parse a dot with space after it at the beginning of a line" do
    lambda {
      test_script_line_node_symbols_and_values ". 555"
    }.should raise_error
  end
  it "should not parse a dot with space before it at the end of a line" do
    lambda {
      test_script_line_node_symbols_and_values "0.45 ."
    }.should raise_error
  end
  it "should parse a colon" do
    test_script_line_node_symbols_and_values ":", :':'
    test_script_line_node_symbols_and_values "1:2", 1, :':', 2
    test_script_line_node_symbols_and_values "10 : \"x\"", 10, :':', 'x'
  end
  it "should parse a comma" do
    test_script_line_node_symbols_and_values ",", :','
    test_script_line_node_symbols_and_values "10, 20, 30", 10, :',', 20, :',', 30
    test_script_line_node_symbols_and_values "'a', 'b', 'c'", 'a', :',', 'b', :',', 'c'
  end
  it "should parse an alphanumeric method" do
    test_script_line_node_symbols_and_values "method", :method
  end
  it "should parse an instance method" do
    test_script_line_node_symbols_and_values "@bob123", :@bob123
  end
  it "should not parse an alphanumeric method beginning with a number" do
    lambda {
      test_script_line_node_symbols_and_values "123hello", :'123hello'
    }.should raise_error
  end
  it "should parse a methods ending with question marks" do
    test_script_line_node_symbols_and_values "bob? @bill?", :bob?, :'@bill?'
  end
  it "should parse a method ending with an exclamation mark" do
    test_script_line_node_symbols_and_values "bob! @betty!", :bob!, :'@betty!'
  end
  it "should parse methods with underscores" do
    test_script_line_node_symbols_and_values "@_bob bob_ bo_bo? __!", :'@_bob', :bob_, :bo_bo?, :__!
  end
  it "should resolve miscellaneous operators" do
    test_script_line_node_symbols_and_values "+ - * / @ %", :+, :-, :*, :/, :'@', :%
  end
  it "should resolve arbitrary compound operators" do
    test_script_line_node_symbols_and_values "<< >> %$ -- ++ @", :<<, :>>, :'%$', :'--', :'++', :'@'
  end
  it "should attach a solitary dash to any following numeric literal" do
    test_script_line_node_symbols_and_values "this-3 that-.5", :this, -3, :that, -0.5    
  end
  it "should split two dashes before a numeric literal" do
    test_script_line_node_symbols_and_values "10--5, 13.6--3.2", 10, :-, -5, :',', 13.6, :-, -3.2
  end
  it "should keep two dashes together as a method before anything that is not a numeric literal" do
    test_script_line_node_symbols_and_values "bob--ted 1--:'that'", :bob, :'--', :ted, 1, :'--', :':', 'that'
  end
  it "should split a dash off the end of a compound symbolic method if followed by a numeric literal" do
    test_script_line_node_symbols_and_values "this %-15 @^--0.1", :this, :%, -15, :'@^-', -0.1
  end
  it "should not parse colons with symbolic methods" do
    test_script_line_node_symbols_and_values "x+:5", :x, :+, :':', 5
  end
end

def test_script_line_tree(text, *match_tree)
  script = new_script('')
  line = cipher('Script','Line').new(script, text, 1)
  tree_to_array(line.tree).should == match_tree
end

def tree_to_array(node)
  arr = []
  (arr << tree_to_array(node.input_node) if node.input_node) rescue nil
  arr << (node.symbol rescue node.value)
  (arr << tree_to_array(node.param_block.tree) if node.param_block) rescue nil
  arr += node.children.map{ |child| tree_to_array(child) } if node.children
  arr.length == 1 ? arr[0] : arr
end

describe "Script::Line#nodes_to_tree" do
  it "should build a tree for a simple assignment" do
    test_script_line_tree "a:1", :':',:a, 1
  end
  it "should build a tree for chained assignment" do
    test_script_line_tree "first:second:3", :':', :first, [:':', :second, 3]
    test_script_line_tree "x:y:-712", :':', :x, [:':', :y, -712]
  end
  it "should build a list of comma-delimited values" do
    test_script_line_tree "1, 2, 3", :',', 1, 2, 3
    test_script_line_tree "'hello',0.13,-45,\"test\"", :',', 'hello', 0.13, -45, "test"
  end
  it "should build a method chain tree for addition" do
    test_script_line_tree "1 + 2", 1, :+, 2
  end
end

def test_line_block_eval(text, values=nil, locals=nil)
  result = new_script_line(text).evaluate(nil)
  if values && values.length > 0
    result.list[0].values.map{ |val| val.value }.should == values
  end
  if locals
    locals.each_pair do |key, value|
      obj = result.locals[key]
      obj.should_not be_nil
      obj.value.should == value
    end
  end
end

describe "Script::Line#evaluate" do
  it "should return a Cipher::Block" do
    new_script_line("").evaluate(nil).should be_a_kind_of(cipher('Block'))
  end
  it "should return a block with no locals and no lines for an empty script" do
    test_line_block_eval "", [], {}
  end
  it "should return a block with one line for simple literals" do
    result = new_script_line('1').evaluate(Cipher::Object.new)
    result.list.size.should == 1
  end
  it "should return a block with an object representing a literal value" do
    test_line_block_eval "100", [100], {}
    test_line_block_eval "-3", [-3], {}
    test_line_block_eval "10.5", [10.5], {}
    test_line_block_eval "-0.4", [-0.4], {}
    test_line_block_eval "'bob'", ['bob'], {}
  end
  it "should return simple literals assignments in the locals hash" do
    test_line_block_eval "value:12", [12], :value => 12
  end
  it "should be able to chain assignments" do
    test_line_block_eval "x:y:-712", [-712], :x => -712, :y => -712
  end
  it "should evaluate a list of comma-delimited literals" do
    test_line_block_eval "1, 'x', -0.3", [1, 'x', -0.3]
  end
  it "should be able to reassign the value of previous assignments in comma-delimited list" do
    test_line_block_eval "aaa:'something', bbb:aaa", ['something', 'something'], :aaa => 'something', :bbb => 'something'
    test_line_block_eval "a:8,b:'x',c:a,d:b", [8,'x', 8, 'x'], :a => 8, :b => 'x', :c => 8, :d => 'x'
  end
  it "should be able to add two integers" do
    test_line_block_eval "10 + 1", [11]
  end
  it "should be able to assign the results of integer addition to a variable" do
    test_line_block_eval "zzz: 100 + 101", [201], :zzz => 201
  end
  it "should be able to reference earlier calulated assignments" do
    test_line_block_eval "abc:25+25, def:abc", [50, 50], :abc => 50, :def => 50
  end 
  it "should be able to add an integer to an integer in a variable" do
    test_line_block_eval "qwerty:-10, asdf: qwerty+5", [-10, -5], :qwerty => -10, :asdf => -5
  end
  it "should be able to add two integer variables together" do
    test_line_block_eval "a:1, b:2, c:a+b", [1,2,3], :a => 1, :b => 2, :c => 3
  end
  it "should be able to add three integers together" do
    test_line_block_eval "1+2+3, 4+5+6", [6,15]
  end
  it "should be able to add two floats together" do
    test_line_block_eval "11.1 + 22.2", [33.3]
  end
  it "should be able to manipulate and add floats in variables" do
    test_line_block_eval "x: 1.5, y: 2.5, z: 3.6, total: x+y+z", [1.5,2.5,3.6,7.6], :x=>1.5, :y=>2.5, :z=>3.6, :total=>7.6
    test_line_block_eval "1+3.5, val: 3 + 5.1", [4.5,8.1], :val=>8.1
  end
  it "should return a float if an integer is added to a float" do
    new_script_line('1+3.5').evaluate(nil).first.should be_a_kind_of(cipher('Float'))
  end
end