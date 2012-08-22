require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

def script_line_token(line, token_index)
  script = new_script(line)
  line = script.lines[0]
  line.tokens[token_index]
end

def test_script_line_literal(line, token_index, klass, value=nil)
  token = script_line_token(line, token_index)
  namespace = (language == :ruby) ? "Cipher::" : "Cipher."
  token.class.to_s.should == "#{namespace}#{klass}"
  token.value.should == value if value
end

def test_script_line_symbols_and_values(line, *match_tokens)
  tokens = new_script(line).lines[0].tokens
  tokens.size.should == match_tokens.size
  tokens.each_with_index do |token, index|
    match = match_tokens[index]
    if token.is_a?Symbol
      token.to_s.should == match.to_s
    else
      token.value.should == match
    end
  end
end

def test_script_line_method(line, token_index, token)
  script_line_token(line, token_index).should == token
end

describe "Script::Line parsing" do
  it "should resolve integers into objects" do
    test_script_line_literal '123', 0, 'Integer', 123
    test_script_line_literal '-893', 0, 'Integer', -893
    test_script_line_literal '0', 0, 'Integer', 0
  end
  it "should resolve floats into objects" do
    test_script_line_literal '142.2', 0, 'Float', 142.2
    test_script_line_literal '0.5', 0, 'Float', 0.5
    test_script_line_literal '-1.99', 0, 'Float', -1.99
    test_script_line_literal '.6666666', 0, 'Float', 0.6666666
  end
  it "should resolve single quote strings into objects" do
    test_script_line_literal "'a string for me'", 0, 'String', 'a string for me'
    test_script_line_literal "'\\\'single\\\' \"double\"'", 0, 'String', '\'single\' "double"'
  end
  it "should resolve single double strings into objects" do
    test_script_line_literal '"a string for you"', 0, 'String', 'a string for you'
  end
  it "should resolve variables and methods into symbols" do
    test_script_line_method 'test_method', 0, :test_method
  end
  it "should resolve the assignment operator ':'" do
    test_script_line_method ':', 0, :':'
  end
  it "should resolve the negation operator '!'" do
    test_script_line_symbols_and_values 'a: !b', :a, ':', '!', :b
  end
  it "should resolve an assignment statement" do
    test_script_line_symbols_and_values "a: 1", :a, ':', 1
    test_script_line_symbols_and_values "variable: 'result'", :variable, ':', 'result'
  end
  it "should resolve a period" do
    test_script_line_symbols_and_values "this.is.amazing", :this, '.', :is, '.', :amazing
  end
  it "should resolve miscellaneous operators" do
    test_script_line_symbols_and_values "+ - * / @ % :", "+", "-", "*", "/", "@", "%", ":"
  end
  it "should resolve arbitrary compound operators" do
    test_script_line_symbols_and_values "<< >> %$ -- ++ @ :: :::", "<<", ">>", "%$", "--", "++", "@", "::", ":::"
  end
  it "should raise an exception for a period preceded by mid-line whitespace" do
    lambda {
      new_script('x .misplaced')
    }.should raise_error
  end
  it "should raise an exception for a period followed by mid-line whitespace" do
    lambda {
      new_script('y. whoops')
    }.should raise_error
  end
  it "should raise an exception for a period at the beginning of a line"
  #   lambda {
  #     new_script('.bad period')
  #   }.should raise_error
  #   lambda {
  #     new_script('    .also a bad period')
  #   }.should raise_error
  # end
  it "should raise an exception for a period at the end of a line"
  #   lambda {
  #     new_script('trailing.')
  #   }.should raise_error
  # end
end