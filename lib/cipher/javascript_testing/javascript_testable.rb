def javascript_testable(file=nil)
  if defined?(TEST_JAVASCRIPT) && TEST_JAVASCRIPT
    extend JavascriptTestable::ClassMethods
    include JavascriptTestable::InstanceMethods
  end
end

module JavascriptTestable
    
  module ClassMethods
    attr_accessor :_chain_, :_args_
    def _no_recursion
      if !@__called__
        @__called__ = true
        yield
        @__called__ = false
      end
    end
    def _add_to_chain_(meth, *args)
      self._chain_ << meth
      self._args_ << args
      self
    end
    def singleton_method_added(meth)
      (@_prototype_properties ||= []) << meth if meth.to_s[-1,1] = '='
      _no_recursion do
        singleton = class << self; self end
        singleton.send :define_method, meth, lambda { |*args| _add_to_chain_(meth,args) }
      end
    end
    def method_added(meth)
      # assignment methods map by default to JavaScript properties rather than functions
      (@_instance_properties ||= []) << meth if meth.to_s[-1,1] = '='
      _no_recursion do
        define_method(meth) { |*args| _add_to_chain_(meth,args) }
      end
    end
  end

  module InstanceMethods
    
  end

end

