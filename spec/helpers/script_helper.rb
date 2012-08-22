def new_script(text)
  s = cipher('Script','Base')
  s.new(text)
end

def new_script_line(text)
  cipher('Script','Line').new(new_script(''), text, 1)
end

module JS::Script
  class JS::Script::Base
  end
end
