# require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

require 'rspec'

class X
  def thing
    Y.new
  end
end


class Y
  def should(*args)
    self.class.superclass.should
  end
end


describe "" do
  it "does" do
    Y.new.should == 10
  end
end