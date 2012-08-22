require 'cipher/object'

class Cipher::String < Cipher::Object
  def self.matcher
    sgl = "'(\\\\'|[^'])*'"
    dbl = '"(\\\\"|[^"])*"'
    sgl + '|' + dbl
  end
  def initialize(args)
    if args.is_a?(Hash) && args[:parse]
      case args[:parse]
      when /^\s*'(.*)'\s*$/
        inner = $1
        raise 'Unescaped single quote in literal string' if inner =~ /^'|.*[^\\]'/
        @value = inner.gsub("\\'", "'")
      when /^\s*"(.*)"\s*$/
        inner = $1
        raise 'Unescaped double quote in literal string' if inner =~ /^"|.*[^\\]"/
        @value = inner.gsub('\\"', '"')
      else
        raise "Unable to parse object as string: #{string.inspect}"
      end
    else
      super
    end
  end
end

