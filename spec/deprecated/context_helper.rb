def context
  if language == :ruby
    Cipher::Context.new
  else
    JS::Context.new
  end
end

class JS::Context
  def initialize
    page.evaluate_script("var context = new Cipher.Context();")
    
    ## THIS IS MADDENING... How does one distinguish between null, zero, false, and empty string consitently????
    
  #   page.execute_script("
  #     function encode_nulls(val){
  #       dump(val, 'Value');
  #       dump(typeof val, 'typeof');
  #       dump(val.length, 'length');
  #       var encoded, i, e;
  #       encoded = val;
  #       if(encoded===null){
  #         return '##NULL##';
  #       }
  #       if((!val)||(typeof val=='string')){
  #         dump(val,'false, zero or string');
  #         return val;
  #       }
  #       encoded = val;
  #       if(encoded instanceof Array){
  #         for(i=0;i<encoded.length;i++){
  #           e = encoded[i];
  #           encoded[i] = encode_nulls(e);
  #         }
  #       }else{
  #         for(key in encoded){
  #           encoded[key] = encode_nulls(encoded[key]);
  #         }
  #       }
  #       dump(encoded, 'Encoded');
  #       return encoded;
  #     }
  #   ")
  
  end
  def decode_nulls(value)
    if value=='##NULL##'
      value = nil
    elsif value.is_a?Array 
      value = value.map{ |e| decode_nulls(e) }
    elsif value.is_a?Hash
      value.keys.each { |key| value[key] = decode_nulls(value[key]) }
    end
    value
  end
  def parse_literal(string)
    script = 'context.parseLiteral(' + string.dump + ')'
    if Capybara.current_driver == :webkit # work around a glitch in Qt Webkit JSON rendering
      script = "(function(){var a=#{script};return [a[0]||false,a[1]||false]})()"
    end
    token, remaining = page.evaluate_script script
    return token ? token : nil, remaining ? remaining : nil
  end
  def assign(key, value)
    page.execute_script 'context.assign("' + key + '",' + value.to_json + ');'
  end
  def locals
    page.evaluate_script('context._locals')
  end
  def set_local(key, value)
    page.execute_script 'context._locals["' + key + '"] = ' + value.to_json + ';'
  end
  def retrieve(key)
    page.evaluate_script('context.retrieve("' + key + '")')
  end
end

