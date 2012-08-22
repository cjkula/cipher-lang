require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

def new_block(locals={}, parent=nil, *lines)
  block = Cipher::Block.new(parent)
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


def line_values(line)
  if language == :ruby
    line.values.map{|v|v.value}
  else
    page.evaluate_script("var vals=#{line}.values, out=[],i;for(i=0;i<vals.length;i++){out.push(vals[i].value)};out")
  end
end

describe "Block::Line" do
  describe "#initialize" do
    it "should not error" do
      lambda {
        line = new_block_line
      }.should_not raise_error
    end
    it "should accept nil/null"
    it "should accept an array of objects" do
      line_values(new_block_line([1,2,3])).should == [1,2,3]
      line_values(new_block_line(['a','b','c'])).should == ['a','b','c']
      
    end
    it "should accept a single object" do
      line_values(new_block_line([-100])).should == [-100]
      line_values(new_block_line([' this, that, other '])).should == [' this, that, other ']
    end
  end
  describe "#class_name" do
    it "should retrieve the class name" do
      new_block_line.class_name.should == 'Line'
    end
  end
  describe "#concatenate" do
    it "should raise an error if argument that is not a Block::Line"
    it "should concatenate two lines with values together"
    it "should work for an empty left-hand line"
    it "should work for an empty right-hand line"
    it "should raise an error for nil/null"
  end
  describe "#append" do
    it "should raise an error if argument is not a Cipher::Object"
    it "should raise an error for a null/nil argument"
    it "should add an object to an empty line" do
      line = new_block_line([])
      line.append objectify('word')
      line_values(line).should == ['word']
    end
    it "should add an object to a non-empty line" do
      line = new_block_line([5,6,7])
      line.append objectify(8)
      line_values(line).should == [5,6,7,8]
    end
  end
  describe "#first" do
    it "should return nil for an empty line"
    it "should return the only item in a one-item line"
    it "should return the [0] position item in a multi-item line" do
      line = new_block_line([10,20,30])
      ## TEMPORARY WORKAROUND AWAITING OVERHAUL OF JS TEST OBJECT REFERENCE TECHNIQUES
      (language==:ruby ? line.first.value : line.this('first().value')).should == 10
    end
  end  
end

def list_object_value(block, coords)
  if language == :ruby
    block.list[coords[0]].values[coords[1]].value
  else
    page.evaluate_script("#{block}.list[#{coords[0]}].values[#{coords[1]}].value")
  end
end

describe "Block" do
  it "can be created" do
    block = nil
    lambda {
      block = new_block
    }.should_not raise_error
    block.class_name.should == 'Block'
  end
  it "can append a value to an empty block in a new line" do
    block = new_block
    obj = objectify('test')
    block.append_value obj
    list_object_value(block,[0,0]).should == 'test'
  end
  it "can append a value to single existing line" do
    block = new_block nil, nil, [1,2]
    obj = objectify(3)
    block.append_value obj 
    list_object_value(block,[0,2]).should == 3
  end
end

describe "Block#first" do
  it "gets the first value in a single line block" do
    block = new_block(nil, nil, ['a','b','c'])
    (language==:ruby ? block.first.value : block.this('first().value')).should == 'a' ## TEMPORARY WORKAROUND
  end
  it "gets the first value in a multi-line block" do
    block = new_block(nil, nil, ['x','y','z'], ['a','b','c'])
    (language==:ruby ? block.first.value : block.this('first().value')).should == 'x' ## TEMPORARY WORKAROUND
  end
end