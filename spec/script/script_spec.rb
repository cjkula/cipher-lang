require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Script" do
  def make_lines(arr)
    arr.join("\n")
  end
  it "should accept a string as a constructor" do
    s = nil
    text = 'a: 10'
    lambda {
      s = new_script(text)
    }.should_not raise_error
    s.text.should == text
  end
  it "should divide a script up into lines" do
    new_script(make_lines ["a: 10","b: 20","c: 30"]).lines.count.should == 3
  end
  it "should divide each line into indent whitespace and content" do
    s = new_script(make_lines ["a: 10","if a > 10","\tif a=20","\t  a: 0","b: a"])
    s.lines.map { |line| line.indent }.should == ["","","\t","\t  ",""]
    s.lines.map { |line| line.content }.should == ["a: 10", "if a > 10", "if a=20", "a: 0", "b: a"]
  end
  it "should arrange lines of raw code into a hierarchy of steps based on indentation" do
    s = new_script(make_lines ["1","2","\t3","\t\t4","\t\t5","6"])
    s.root_lines.count.should == 3
    s.root_lines[0].block.should be_nil
    s.root_lines[1].block.root_lines.count.should == 1
    s.root_lines[1].block.root_lines[0].block.root_lines.count.should == 2
    s.root_lines[1].block.root_lines[0].block.root_lines[0].block.should be_nil
    s.root_lines[1].block.root_lines[0].block.root_lines[1].block.should be_nil
    s.root_lines[2].block.should be_nil
  end
  it "should arrange lines correctly for a script with the final line of code indented" do
    s = new_script(make_lines ["1","\t2","\t\t3"])
    s.root_lines.count.should == 1
    s.root_lines[0].block.root_lines.count.should == 1
    s.root_lines[0].block.root_lines[0].block.root_lines.count.should == 1
    s.root_lines[0].block.root_lines[0].block.root_lines[0].block.should be_nil
  end
  it "should process a single line correctly" do
    s = new_script("a: 1")
    s.root_lines.count.should == 1
    s.root_lines[0].block.should be_nil
  end
end
