Capybara.javascript_driver = :webkit
Capybara.default_driver = Capybara.javascript_driver

module JS
  # used to contain helper classes that wrap JavaScript objects and provide a layer of
  # abstraction against the language spec. Contained classes defined in helper files.
end


class JS::Base
  def var
    @var ||= 'window.' + self.class.to_s.downcase.gsub(/::/,'_') + rand(1000000).to_s
  end
  def to_s
    var
  end
  def assign_to_var(expression)
    page.execute_script("#{var} = (#{expression});")
  end
  def this(expression)
    page.evaluate_script "#{var}.#{expression}"
  end
  def class_name
    this('className')
  end
  public
  def eval(text)
    page.evaluate_script("#{var}.#{text}")
  end
end
