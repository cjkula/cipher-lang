module PourCoffee
  def self.all
    Dir.glob("#{COFFEE_PATH}/*.coffee").each do |file|
      file =~ /\b(\w*).coffee$/i
      compile_if_dated($1)
    end
  end
  def self.compile_if_dated(name)
    coffee_path = "#{COFFEE_PATH}/#{name}.coffee"
    return unless File.exists?(coffee_path).inspect
    js_path = "#{JS_PATH}/#{name}.js"
    return if File.exists?(js_path) && (File.mtime(coffee_path) < File.mtime(js_path))
    compile(name)
  end
  def self.compile(name)
    puts "COMPILING #{COFFEE_PATH}/#{name}.coffee to javascript"
    js = CoffeeScript.compile File.read("#{COFFEE_PATH}/#{name}.coffee")
    File.open("#{JS_PATH}/#{name}.js", 'w') {|f| f.write(js) }
  end

end

PourCoffee.all