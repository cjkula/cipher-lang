require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Context#assign / Context#retrieve" do
  before(:each) do
    @context = context
  end
  it "should store an arbitrary value" do
    @context.assign('x', [1,2,3])
    @context.locals['x'].should == [1,2,3]
  end
  it "should retrieve a value", :ruby_only => true do
    @context.locals['y'] = {:a=>:b}
    @context.retrieve('y').should == {:a=>:b}
  end
  it "should retrieve a value", :js_only => true do
    @context.set_local('y', {"a"=>"b"})
    @context.retrieve('y').should == {"a"=>"b"}
  end
  it "should store and retrieve a value" do
    @context.assign('that', 'testing')
    @context.retrieve('that').should == 'testing'
  end
end

describe "Context#evaluate" do
  it "should create a script object" do
    
  end
end

# describe "Context#parse_literal" do
#   def parse_literal(string, token, remaining=nil)
#     method, overflow = context.parse_literal(string)
#     method.should == token
#     overflow.should == remaining
#   end
#   it "should parse an integer" do
#      parse_literal '123', '123', nil
#   end
#   it "should parse an integer with leading whitespace and remaining characters" do
#     parse_literal ' 101 hey bada bada', '101', ' hey bada bada'
#   end
#   it "should parse a negative integer followed by another negative integer" do
#     parse_literal '-15 -12', '-15', ' -12'
#   end
#   it "should parse a floating point number" do
#     parse_literal '0.25 "teddy"', '0.25', ' "teddy"'
#   end
#   it "should parse a negative floating point number with leading whitespace and followed by a token" do
#     parse_literal ' 2 token',              '2',     ' token'
#   end
#   it "should parse a single-quote string literal" do
#     parse_literal "'a great string, I \"think\"! : )' x, y",   "'a great string, I \"think\"! : )'",   " x, y"
#   end
#   it "should parse a double-quote string literal" do
#     parse_literal ' "another string! \'Awesome\'? : |" "bob"',   '"another string! \'Awesome\'? : |"', ' "bob"'
#   end
#   it "should parse a numeric literal followed by a dot method" do
#     parse_literal "34.add 5", "34", ".add 5"
#   end
#   it "should parse a single-quote string literal followed by a dot method" do
#     parse_literal " 'this is a test'.strip 5", "'this is a test'", ".strip 5"
#   end
#   it "should parse a double-quote string literal followed by a dot method" do
#     parse_literal '"It\'s never too late for now".later.later_still -45.0000000001', '"It\'s never too late for now"', '.later.later_still -45.0000000001'
#   end
#   it "should not parse a token" do
#     parse_literal "bob", nil, "bob"
#   end
#   it "should not parse a token with leading whitespace and followed by a token" do
#     parse_literal " XKCD rules", nil, " XKCD rules"
#   end
#   it "should not parse a token and operator method" do
#     parse_literal "x+3", nil, "x+3"
#   end
#   it "should parse an integer and operator method" do
#     parse_literal "24 >>-34", "24", " >>-34"
#   end
#   it "should parse a single quote string and operator method" do
#     parse_literal " 'test, this'+3", "'test, this'", "+3"
#   end
#   it "should parse a double quote and operator method" do
#     parse_literal ' "double, quote, string" << "bob"', '"double, quote, string"', ' << "bob"'
#   end
# end

# describe "Context#resolve_literal" do
#   def resolve_literal(string, klass, value, remaining=nil)
#     object, overflow = context.resolve_literal(string)
#     object.class.to_s.should == klass
#     object.value.should == value
#     overflow.should == remaining
#   end
#   it "should parse an integer" do
#      parse_literal '123', 'Integer', 123, nil
#   end
#   it "should parse an integer with leading whitespace and remaining characters" do
#     parse_literal ' 101 hey bada bada', 'Integer', 101, ' hey bada bada'
#   end
#   it "should parse a negative integer followed by another negative integer" do
#     parse_literal '-15 -12', 'Integer', -15, ' -12'
#   end
#   it "should parse a floating point number" do
#     parse_literal '0.25 "teddy"', 'Float', 0.25, ' "teddy"'
#   end
#   it "should parse a negative floating point number with leading whitespace and followed by a token" do
#     parse_literal ' -2.22 token', 'Float', -2.22, ' token'
#   end
#   it "should parse a single-quote string literal" do
#     parse_literal "'a great string, I \"think\"! : )' x, y",   "'a great string, I \"think\"! : )'",   " x, y"
#   end
#   it "should parse a double-quote string literal" do
#     parse_literal ' "another string! \'Awesome\'? : |" "bob"',   '"another string! \'Awesome\'? : |"', ' "bob"'
#   end
#   it "should parse a numeric literal followed by a dot method" do
#     parse_literal "34.add 5", "34", ".add 5"
#   end
#   it "should parse a single-quote string literal followed by a dot method" do
#     parse_literal " 'this is a test'.strip 5", "'this is a test'", ".strip 5"
#   end
#   it "should parse a double-quote string literal followed by a dot method" do
#     parse_literal '"It\'s never too late for now".later.later_still -45.0000000001', '"It\'s never too late for now"', '.later.later_still -45.0000000001'
#   end
#   it "should not parse a token" do
#     parse_literal "bob", nil, "bob"
#   end
#   it "should not parse a token with leading whitespace and followed by a token" do
#     parse_literal " XKCD rules", nil, " XKCD rules"
#   end
#   it "should not parse a token and operator method" do
#     parse_literal "x+3", nil, "x+3"
#   end
#   it "should parse an integer and operator method" do
#     parse_literal "24 >>-34", "24", " >>-34"
#   end
#   it "should parse a single quote string and operator method" do
#     parse_literal " 'test, this'+3", "'test, this'", "+3"
#   end
#   it "should parse a double quote and operator method" do
#     parse_literal ' "double, quote, string" << "bob"', '"double, quote, string"', ' << "bob"'
#   end
# end


# describe "Context#parse_qualified_method" do
#   def parse_method(string, token, remaining=nil)
#     method, overflow = context.parse_qualified_method(string)
#     method.should == token
#     overflow.should == remaining if remaining
#   end
#   it "should parse an integer" do
#     parse_method '123', '123', nil
#   end
#   it "should parse an integer with leading whitespace and remaining characters" do
#     parse_method ' 101 hey bada bada', '101', ' hey bada bada'
#   end
#   it "should parse a negative integer followed by another negative integer" do
#     parse_method '-15 -12', '-15', ' -12'
#   end
#   it "should parse a floating point number" do
#     parse_method '0.25 "teddy"', '0.25', ' "teddy"'
#   end
#   it "should parse a negative floating point number with leading whitespace and followed by a token" do
#     parse_method ' 2 token',              '2',     ' token'
#   end
#   it "should parse a single-quote string literal" do
#     parse_method "'a great string, I \"think\"! : )' x, y",   "'a great string, I \"think\"! : )'",   " x, y"
#   end
#   it "should parse a double-quote string literal" do
#     parse_method ' "another string! \'Awesome\'? : |" "bob"',   '"another string! \'Awesome\'? : |"', ' "bob"'
#   end
#   it "should parse a numeric literal followed by a dot method" do
#     parse_method "34.add 5", "34.add", " 5"
#   end
#   it "should parse a single-quote string literal followed by a dot method" do
#     parse_method " 'this is a test'.strip 5", "'this is a test'.strip", " 5"
#   end
#   it "should parse a double-quote string literal followed by a dot method" do
#     parse_method '"It\'s never too late for now".later.later_still -45.0000000001', '"It\'s never too late for now".later.later_still', ' -45.0000000001'
#   end
#   it "should parse a token" do
#     parse_method "bob", "bob", nil
#   end
#   it "should parse a token with leading whitespace and followed by a token" do
#     parse_method " XKCD rules", "XKCD", " rules"
#   end
#   it "should parse a token and operator method" do
#     parse_method "x+3", "x+", "3"
#   end
#   it "should parse an integer and operator method" do
#     parse_method "24 >>-34", "24 >>", "-34"
#   end
#   it "should parse a single quote string and operator method" do
#     parse_method " 'test, this'+3", "'test, this'+", "3"
#   end
#   it "should parse a double quote and operator method" do
#     parse_method ' "double, quote, string" << "bob"', '"double, quote, string" <<', ' "bob"'
#   end
# end

# describe "Context#parse_token" do
#   def parse_token(string, first, remaining=nil)
#     token, overflow = context.parse_token(string)
#     token.should == first
#     overflow.should == remaining if remaining
#   end
#   it "should not parse an integer" do
#     parse_token '10', nil, '10'
#     parse_token ' 123', nil, ' 123'
#   end
#   it "should not parse a decimal value" do
#     parse_token '2.5', nil, '2.5'
#     parse_token ' 1.23', nil, ' 1.23'
#   end
#   it "should not parse a negative number" do
#     parse_token '-2', nil, '-2'
#     parse_token ' -1', nil, ' -1'
#   end
#   it "should not parse a single quote string literal" do
#     parse_token "'test1'", nil, "'test1'"
#     parse_token " 'test2' ", nil, " 'test2' "
#   end
#   it "should not parse a double quote string literal" do
#     parse_token '"hi"', nil, '"hi"'
#     parse_token ' "hello" ', nil, ' "hello" '
#   end
#   it "should not parse a double quote string literal" do
#     parse_token '"hi"', nil, '"hi"'
#     parse_token ' "hello" ', nil, ' "hello" '
#   end
#   it "should parse an alphanumeric word" do
#     parse_token 'method1', 'method1', nil
#     parse_token ' method2 ', 'method2', nil
#   end
#   it "should not parse an alphanumeric beginning with a number" do
#     parse_token '1method', nil, '1method'
#     parse_token ' 2method ', nil, ' 2method '
#   end
#   it "should not parse a dot method after token" do
#     parse_token 'object.method', 'object', '.method'
#     parse_token ' object.method', 'object', '.method'
#   end
# end
  
# describe "Context#method?" do
#   it "should return true for the string name of an existing instance method" do
#     context.method?('method?').should be_true
#   end
#   it "should return true for the symbol of an existing instance method" do
#     context.method?(:method?).should be_true
#   end
#   it "should return false for the string name of an existing instance method" do
#     context.method?('__this_is_not_a_method__').should be_false
#   end
#   it "should return false for the symbol of an existing instance method" do
#     context.method?(:__this_is_not_a_method__).should be_false
#   end
# end
#   
# describe "Context#resolve" do
#   def resolve(qualified_method, object_class, object_value, method)
#     return_object, return_method = context.resolve(qualified_method)
#     return_object.class.should == object_class
#     return_object.value.should == object_value
#     return_method.should == method if method
#   end
#   it "should resolve an integer" do
#     resolve('123', Cipher::Integer, 123, nil)
#   end
#   it "should resolve an integer followed by a method" do
#     resolve('4567.square', Cipher::Integer, 4567, 'square')
#   end
#   it "should resolve a floating point number" do
#     resolve('0.31', Cipher::Float, 0.31, nil)
#   end
#   it "should resolve a floating point number followed by a method" do
#     resolve('4567.3421.floor', Cipher::Float, 4567.3421, 'floor')
#   end
#   it "should resolve a negative integer followed by a method" do
#     resolve('-10.abs', Cipher::Integer, -10, 'abs')
#   end
#   it "should resolve a negative float object followed by a method" do
#     resolve('-10.abs', Cipher::Integer, -10, 'abs')
#   end
# end

# describe "Script runner" do
#   it "should return nil for an empty script" do
#     run("").should be_nil
#   end
#   it "should break lines up into steps" do
#     Closure.new("step 1\nstep 2").steps.length.should == 2
#   end
#   it "should set closure reference for create steps" do
#     closure = Closure.new("step 1\nstep 2")
#     closure.steps.each do |step|
#       step.closure.should == closure
#     end
#   end
#   it "should be able to raise an exception with the 'raise' keyword" do
#     lambda { run("raise") }.should raise_error
#   end
#   it "should return the last evaluated expression" do
#     run("12345").should == 12345
#     run("12345\n9090").should == 9090
#   end
#   it "should return an expression using the 'return' keyword" do
#     run("10\nreturn 123\n9090").should == 123
#   end
# end