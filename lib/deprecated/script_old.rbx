module Cipher

  class Cipher::Script
    attr_accessor :context, :text, :steps, :current, :locals
  
    def initialize(text, context)
      @context = context
      @text = text
      @steps = @text.split(/$/).map { |line| Cipher::Script::Step.new(line, self) }
    end
  
    def run
      steps.each { |s| s.run }
    end
  
    class Cipher::Script::Step
      attr_accessor :script, :context, :text, :outputs, :method, :inputs

      def initialize(text, script)
        @text = text
        @script = script
        @context = script.context
        parse
      end
      
      def run
        results = @closure.execute(@method, @inputs)
        raise 'Mismatched number of assignments' if @outputs.length > results.length
        @outputs.each_with_index do |output, index|
          @closure.assign(output, results[index])
        end
        results
      end

      private

      def parse
        # @text =~ /^([\w\s\,\.]*)(=)?(.*)$/
        # outputs = $2 ? $1 : ''
        # operation = $2 ? $3 : "#{$1}#{$3}"
        # raise 'Missing left hand of assignment' if $2 && $1.strip==''
        # @outputs = outputs.split(',',-1).map{ |o| o.strip } # -1 arg to split does not surpress trailing commas
        # @outputs.each { |o| raise 'Unexpected comma' if o=='' }
        # 
        # method, remaining = @closure.parse_method(operation)
        # 
        # 
        # 
        # 
        # 
        # 
        # 
        # literal, remaining = @closure.parse_literal(operation)
        # if literal
        #   @method = literal
        #   space = (remaining =~ /^\s/)
        # else
        #   operation =~ /^\s*([\w\.]+\s*[^\w\s'"]*)(\s*)(.*)$/
        #   @method = $1.strip
        #   space = $2.length > 0
        #   remaining = $3
        # end
        # @inputs = split_args(remaining || '')
        # if @method == ',' # no operation -- it's a list of arguments
        #   @inputs.unshift @method
        #   @method = '='   # echo inputs method
        # elsif !space && (@method =~ /\-$/) && (@inputs[0]) && (@inputs[0] =~ /^\d*\.?\d+$/)
        #   # dash in method is really a negative sign
        #   @inputs[0] = '-' + @inputs[0]
        #   @method.chop!.strip!
        # end
      end

      def split_args(string)
        last = nil
        remaining = string.strip
        args = []
        while remaining.length > 0
          case remaining
          when /^,/
            raise 'Unexpected comma' if !last || last==','
          when /^#{@closure.literal_matcher}/,   # string or numeric literal
               /^[\w\.]+/                 # token
            raise 'Expected line end or comma' if last && last!=','
            args << $&
          end
          last = $&
          remaining = remaining[$&.length..-1].strip
        end
        raise 'Trailing comma' if last==','
        args
      end
    
    end
  
  
  end
  
end