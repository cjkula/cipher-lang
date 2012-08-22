require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Script" do
  def make_lines(arr)
    arr.join("\n")
  end
  it "should accept a string as a constructor" do
    s = nil
    text = 'a: 10'
    lambda {
      s = Cipher::Script::Base.new(text)
    }.should_not raise_error
    s.text.should == text
  end
end