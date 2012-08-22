require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
require 'coffee-script'

coffee = "
class window.TestClass
  constructor: ->
    @created = true
  classProperty: 'my class property'
  doFunction: ()->
    'class function'
  getThis: ()->
    return this;
"
js = CoffeeScript.compile(coffee)

describe "CoffeeScript instance methods" do
  before(:each) do
    page.execute_script(js)
    page.evaluate_script('var testObject = new TestClass()')
    page.evaluate_script('var testObject2 = new TestClass()')
  end
  it "should compile" do
    js.should_not be_nil
  end
  it "should be able to create a class object" do
    page.evaluate_script('testObject').should_not be_nil
  end
  it "should be possible to reference a property of an object" do
    page.evaluate_script('testObject.created').should == true
  end
  it "should be possible to set a property of an object" do
    page.execute_script('testObject.created = false;')
    page.evaluate_script('testObject.created').should == false
  end
  it "should be possible to have different properties on different objects" do
    page.execute_script('testObject2.created = false;')
    page.evaluate_script('testObject.created').should == true
    page.evaluate_script('testObject2.created').should == false
  end
end

describe "Coffee Script class methods" do
  before(:each) do
    page.execute_script(js)
  end
  it "should be possible to reference the class" do
    page.evaluate_script('TestClass').should_not be_nil
  end
  it "should be possible to reference class properties directly" do
    page.evaluate_script('TestClass.prototype.classProperty').should == 'my class property'
  end
  it "should be possible to reference class functions directly" do
    page.evaluate_script('TestClass.prototype.doFunction()').should == 'class function'
  end
  it "should recognize 'this' as the prototype object in class functions" do
    page.evaluate_script('TestClass.prototype.getThis().classProperty').should == 'my class property'
  end
end




