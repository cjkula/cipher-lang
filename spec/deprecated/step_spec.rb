require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

def step(text)
  c = Closure.new(text)
  c.steps[0]
end
def run_step(text)
  step(text).run
end
def step_outputs_method_inputs(step, outputs, method, inputs)
  step.outputs.should == outputs
  step.method.should == method
  step.inputs.should == inputs
end
def text_outputs_method_inputs(text, outputs, method, inputs)
  s = step(text)
  step_outputs_method_inputs(s, outputs, method, inputs)
  s
end

describe "Script runner step" do
  it "should recognize an integer literal" do
    text_outputs_method_inputs "102030", [], "102030", []
  end
  it "should recognize a closure instance method" do
    text_outputs_method_inputs "bob", [], "bob", []
  end
  it "should recognize a dot-notation method" do
    text_outputs_method_inputs "Integer.squeeze", [], "Integer.squeeze", []
  end
  it "should recognize a multi-dot-notation method" do
    text_outputs_method_inputs "Integer.Negative.squeeze", [], "Integer.Negative.squeeze", []
  end
  it "should recognize a single output" do
    text_outputs_method_inputs "x = test 1, 2, 3", ['x'], "test", ['1','2','3']
  end
  it "should recognize multiple outputs" do
    text_outputs_method_inputs "x, y, z = test 1, 2, 3", ['x','y','z'], "test", ['1','2','3']
  end
  it "should parse an argument list of tokens" do
    text_outputs_method_inputs "test ab, CD.ef, gh.ij", [], "test", ['ab', 'CD.ef', 'gh.ij']
  end
  it "should parse an argument list of numeric literals" do
    text_outputs_method_inputs "test -15.23, 021, -43, .2357483", [], "test", ['-15.23', '021', '-43', '.2357483']
  end
  it "should parse an argument list of string literals" do
    text_outputs_method_inputs "test '1', '\"2\"', \"3\", \"'4'\", '5,6'", [], "test", ["'1'", "'\"2\"'", '"3"', '"\'4\'"', "'5,6'"]
  end
  it "should parse operator methods" do
    text_outputs_method_inputs "x = a + b", ['x'], 'a +', ['b']
    text_outputs_method_inputs "x = a - 5", ['x'], 'a -', ['5']
    text_outputs_method_inputs "x = a - -0.5", ['x'], 'a -', ['-0.5']
    text_outputs_method_inputs "a + -5023", [], 'a +', ['-5023']
    text_outputs_method_inputs "a<<b", [], 'a<<', ['b']
    text_outputs_method_inputs "x, y = a >> -5", ['x', 'y'], 'a >>', ['-5']
    text_outputs_method_inputs "TestCase.this--", [], 'TestCase.this--', []
  end
  it "should raise an exception for misplaced commas in argument list" do
    lambda { step("x=test a,,b, c") }.should raise_error
    lambda { step("a,b,c = a,b,") }.should raise_error
    lambda { step("test,") }.should raise_error
  end
  it "should raise an exception for misplaced commas in output list" do
    lambda { step("x,=test") }.should raise_error
    lambda { step("a,,c= test") }.should raise_error
    lambda { step(",c = test") }.should raise_error
    lambda { step(", = test") }.should raise_error
  end
  it "should raise an exception when missing left hand of assignment" do
    lambda { run_step("= 42") }.should raise_error
  end
  it "should evaluate integer literals" do
    run_step("12345")[0].value.should == 12345
    run_step("-32")[0].value.should == -32
  end
  it "should evaluate decimal literals" do
    run_step("123.45")[0].value.should == 123.45
    run_step("-.5")[0].value.should == -0.5
  end
  it "should evaluate double quote string literals" do
    run_step("'howdy'")[0].value.should == 'howdy'
  end
  it "should evaluate single quote string literals" do
    run_step('"pardner"')[0].value.should == 'pardner'
  end
  it "should be able to assign a value to a variable of the closure" do
    c = Closure.new('x = 1000')
    c.steps[0].run
    c.locals['x'].value.should == 1000
  end
  it "should be able to read a variable of the closure" do
    c = Closure.new('x = y')
    c.assign 'y', Cipher::String.new(:value=>"success")
    c.steps[0].run
    c.locals['x'].value.should == 'success'
  end
  it "should do parallel assignment" do
    result = run_step("a, b = 10, 20")
    result[0].value.should == 10
    result[1].value.should == 20
  end
  
  # it "should raise an exception with the 'raise' keyword" do
  #   lambda { run_step("raise") }.should raise_error('test')
  # end
end
