require File.dirname(__FILE__) + '/javascript_testable.rb'

TEST_JAVASCRIPT = true

class Awesome
  javascript_testable
  attr_accessor :first
  attr_reader :second
  attr_writer :third
  def self.inherited_meth
    'inherited_meth ORIGINAL'
  end
  def awesome_method
    'awesome_method ORIGINAL'
  end
end

class Cipher; end
class Cipher::Block < Awesome
  # javascript_testable
  attr_accessor :fourth
  attr_reader :fifth
  attr_writer :sixth
  # attr_accessor :value
  def self.some_class_meth
    'some_class_meth ORIGINAL'
  end
  def some_instance_meth
    'some_instance_meth ORIGINAL'
  end
  # puts @javascript_object_variables.inspect
end

b = Cipher::Block.new

puts "-------------"
puts Cipher::Block.inherited_meth(1,2,3).inspect
puts Cipher::Block.some_class_meth(4,5,6).inspect
puts b.awesome_method.inspect
puts b.some_instance_meth.inspect

