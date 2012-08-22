class Cipher::Context
  attr_accessor :locals
  def initialize(caller=nil)
    @caller = caller
    @locals = {}
  end
  def assign(local, value)
    @locals[local] = value
  end
  def retrieve(local)
    @locals[local]
  end
  def _
    
  end
  
  
  
  
  
#  def run
#    steps.each { |s| s.run }
#  end

 # def parse_token(string)
 #   if string =~ /^(\s*[a-zA-Z]\w*)(\.| )?.*/
 #     remaining = string[$1.length..-1]
 #     return $1.strip, remaining =~ /^\s*$/ ? nil : remaining
 #   else
 #     return nil, string
 #   end
 # end
 # 
 # def method?(name)
 #   self.class.instance_methods.include?(name.to_sym)
 # end
 # 
 # def resolve(qualified_method)
 #   token, method = self.parse_token(qualified_method)
 #   # puts "[closure.resolve] qualified: #{qualified_method.inspect} / token: #{token.inspect} / method: #{method.inspect}"
 #   if token
 #     object = retrieve(token)
 #     return object, method if object
 #     return self, qualified_method if method?(qualified_method)
 #   end
 #   return Cipher::Object.resolve(qualified_method)
 # end

#  def execute(qualified_method, args)
#    object, method = resolve(qualified_method)
#    method ? object.send(method, *args) : [object]
#  end

 # def literal_matcher
 #   Cipher::Literal.matcher
 # end

  # def parse_qualified_method(string)
  #   token, remaining = parse_literal(string)  # call literal class's definition to parse beginning of string
  #   if !token                                 # if no literal found
  #     string =~ /^(\s*\w+)(.*)/               # parse first word
  #     token = $1.strip
  #     remaining = $2
  #   end
  #   return token, nil unless remaining && remaining.length>0  # return if token is end of string
  #   if remaining =~ /^(\.\w+)*((\.|\s*)[^\w\s\'\"]+)?/        # extended dot notation and method catcher
  #     token += $&                                             #   add anything it found
  #     remaining = remaining[$&.length..-1]                    #   and reduce the remaining string to compensate
  #   end
  #   if remaining =~ /\d*\.?\d+/
  #     if token =~ /(.*?)(\s*-)$/
  #       token = $1
  #       remaining = $2 + remaining
  #     end
  #   end
  #   remaining = nil if remaining =~ /^\s*$/                   # return nil for empty remaining string
  #   return token, remaining
  # end
  # 
  # def parse_literal(string)
  #  if string =~ /^(\s*(#{self.literal_matcher}))/
  #    remain = string[$&.length..-1]
  #    return $1.strip, remain=~/^\s*$/ ? nil : remain
  #  else
  #    return nil, string
  #  end
  # end
  
  # def resolve_literal(string)
  #   token, remaining = parse_literal(string)
  #   return nil, string if !token
  #   return Cipher::Object.find_or_create(token), remaining
  # end
  # 
  # 
  # def resolve_method(string)
  #   if string =~ /^\s*\w+/
  #     remain = string[$&.length..-1]
  #     return $&.strip.to_sym, remain=~/^\s*$/ ? nil : remain
  #   else
  #     return nil, string
  #   end    
  # end
  # 
  # def resolve_dot(string)
  #   if string =~ /^(\s*)\.(\s*)/
  #     raise Cipher::Script::ParsingError if ($1.length > 0) || ($2.length > 0)
  #     remain = string[1..-1]
  #     return :'.', remain=~/^\s*$/ ? nil : remain
  #   else
  #     return nil, string
  #   end    
  # end
  # 
  # def resolve_one_character_token(string)
  #   if string =~ /^\s*[\!\[\]\{\}\(\)]/
  #     remain = string[$&.length..-1]
  #     return $&.strip.to_sym, remain=~/^\s*$/ ? nil : remain
  #   else
  #     return nil, string
  #   end    
  # end
  # 
  # def resolve_operator(string)
  #   if string =~ /^\s*[^\w\s\.\'\"\!\[\]\{\}\(\)]+/
  #     remain = string[$&.length..-1]
  #     return $&.strip.to_sym, remain=~/^\s*$/ ? nil : remain
  #   else
  #     return nil, string
  #   end    
  # end
  
  # def resolve_token(string)
  #   token, remaining = resolve_literal(string)
  #   return token, remaining if token
  #   token, remaining = resolve_dot(string)
  #   return token, remaining if token
  #   token, remaining = resolve_method(string)
  #   return token, remaining if token
  #   token, remaining = resolve_operator(string)
  #   return token, remaining if token
  #   raise Cipher::Script::ParsingError
  # end
  
  
end
