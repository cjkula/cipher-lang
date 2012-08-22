require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Object" do
  it "can be created" do
    lambda {
      Cipher::Object.new
    }.should_not raise_error
  end
end

describe "Object#evaluate" do
  it "should create a script object and call its run method, passing the object" do
    script_double = double(new_script(''))
    cipher('Script','Base').should_receive(:new).and_return(script_double)
    obj = new_object
    script_double.should_receive(:run).with(obj)
    obj.evaluate('')
  end
  it "should return an empty sequence for an empty script" do
    new_object.evaluate('').lines.should == []
  end
  it "should return a sequence matching the number of root lines in a script" do
    new_object.evaluate('5').lines.size.should == 1
    new_object.evaluate("10\n20").lines.size.should == 2
  end
  it "should return a sequence with elements matching simple literals" do
    seq = new_object.evaluate("23\n-0.1234\n'hello world.'\n\"double quotes\"").lines
    seq[0].value.should == 23
    seq[1].value.should == -0.1234
    seq[2].value.should == 'hello world.'
    seq[3].value.should == 'double quotes'
  end
  it "should save return simple literals assignments in the locals hash" do
    new_object.evaluate("value:12").locals['value'].value.should == 12
  end
  it "should be able to assign the value of one local variable to another" do
    new_object.evaluate("a:'test'\nb:a").locals['b'].value.should == 'test'
  end
  it "should be able to chain assignments" do
    result = new_object.evaluate("x:y:-712")
    result.locals['y'].value.should == -712
    result.locals['x'].value.should == -712
  end
  it "should be able to add two number together" do
    new_object.evaluate("x:5+25").locals['x'].value.should == 30
  end
end