
# -- Inadvisable RSpec experiments --

def self.describe string, options={}, &block
  save_driver = Capybara.default_driver
  Capybara.default_driver = Capybara.javascript_driver if TEST_JAVASCRIPT
  super
  Capybara.default_driver = save_driver
end

def self.describe string, options={}, &block
  super string, options.update(:test=>true), block
  super string + ' - JS', options.update(:test=>true), block
end

def self.describe *describe_args
  def self.ruby(*args) #name, opts={}
    # if TEST_RUBY
      it "should" do #{}"[Ruby] #{name}", opts do
        5.should == 5
        # yield
      end
    # end
  end
  # def js *args
  #   if TEST_JAVASCRIPT
  #     args[0] ||= "[Javascript/Webkit] #{args[0]}"
  #     args[1] ||= {}
  #     args[1].update :driver => :webkit
  #     it *args do
  #        yield
  #     end
  #   end
  # end
  # def all *args
  #   if TEST_JAVASCRIPT
  #     js *args do
  #       yield
  #     end
  #   elsif TEST_RUBY
  #     ruby *args do 
  #       yield
  #     end
  #   end
  # end
  super
end

module ItTestsRuby
  def it(string, options={}, &block)
    super '[Ruby] ' + string, options, block if TEST_RUBY
  end
end
module ItTestsJavascript
  def it(string, options={})
    super '[Javascript/Webkit] ' + string, {:driver => :webkit} if TEST_JAVASCRIPT
  end
end
# module ItTestsAll
#   def it(string, options={})
#     super '[Javascript/Webkit] ' + string, {:driver => :webkit} if TEST_JAVASCRIPT
#     super '[Ruby] ' + string, options if TEST_RUBY
#   end
# end
module ItTestsNone
  def it(string, options={})
  end
end

def languages(which)
  case which
  when :ruby
    extend ItTestsRuby
  when :javascript
    extend ItTestsJavascript
  when :all
    if TEST_JAVASCRIPT
      extend ItTestsJavascript
    else
      extend ItTestsRuby
    end
  else
    extend ItTestsNone
  end
end
