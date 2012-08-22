require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Process" do
  it "should be an object" do
    should_be_a_kind_of(new_process, 'Object')
  end
  it "should accept a script to run" do
    lambda {
      new_process.evaluate '1, 2, 3'
    }.should_not raise_error
  end
end

describe "Process#evaluate" do
  it "should instantiate a script object" do
    cipher('Script').should_receive(:new)
    new_process.evaluate('a: b')
  end
  it "should return a kind of Context" , :ruby_only => true do
    result = new_process.evaluate('a: b')
    should_be_a_kind_of(result, 'Context')
  end
  it "should return a Hash object", :js_only => true # do
  #   new_process.evaluate('return "Hello, world."').should == '"Hello, world."'
  # end  
  it "should return the object created from a single, simple expression using the underscore (_) method" do
    result = new_process.evaluate('12345')._.value.should == 12345
  end
  
end