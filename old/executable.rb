module Cipher
  module Executable

    module ClassMethods
      def initialize
        @_psuedo_class_methods = {}
        @_psuedo_instance_methods = {}
      end
      def define_psuedo_class_method(method_name, &block)
        @_psuedo_class_methods[method_name] = block
      end
      def define_psuedo_method(method_name, &block)
        @_psuedo_instance_methods[method_name] = block
      end
      def class_method?(string)
        @_psuedo_class_methods.keys.include?(string)
      end
      def method?(string)
        @_psuedo_instance_methods.keys.include?(string)
      end
      def call(method, args)
        @_psuedo_class_methods[method].call(args)
      end
    end

    module InstanceMethods
      def class_method?(string)
        self.class.class_method?(string)
      end
      def method?(string)
        self.class.method?(string)
      end
      def call(method, args)
        @_psuedo_instance_methods[method].call(args)
      end
    end

  end
end

