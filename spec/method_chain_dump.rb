class JS
  attr_accessor :chain
  attr_accessor :arg_lists
  def initialize
    @chain = []
    @arg_lists = []
  end
  def method_missing(meth, *args, &block)
    self.chain << meth
    self.arg_lists << args
    self
  end
  def should *args
    "#{javascript_method_chain}.should(#{})"
  end
  def should_not *args
    "#{javascript_method_chain}.should(#{args_to_string(args)})"
  end
  def javascript_method_chain
    text = ""
    @chain.each_with_index do |meth, index|
      args_text = args_to_string(*@arg_lists[index])
      if meth == :[]
        text += "[#{args_text}]"
      else
        text += ".#{meth}(#{args_text})"
      end
    end
    text
  end
  def args_to_string *args
    args.map{|a| a.inspect}.join(', ')
  end
end

# puts ((Chain.new)).inspect

puts JS.new.hello[0,1].there(1)
puts JS.new.hello[1]