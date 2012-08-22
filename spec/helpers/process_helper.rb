def new_process
  if language == :ruby
    Cipher::Process.new
  else
    JS::Process.new
  end
end

class JS::Process
  
end
