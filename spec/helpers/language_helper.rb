def constantize(class_name)
  unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ class_name
    raise NameError, "#{class_name.inspect} is not a valid constant name!"
  end
  Object.module_eval("::#{$1}", __FILE__, __LINE__)
end

def cipher(*klasses) 
  namespace = (language == :ruby) ? 'Cipher' : 'JS'
  constantize(([namespace]+klasses).join('::'))
end

def should_be_a_kind_of(object, *klasses)
  object.should be_a_kind_of cipher(*klasses)
end

def cipher_class_stub(klass, method)
  cipher(klass).stub method
end