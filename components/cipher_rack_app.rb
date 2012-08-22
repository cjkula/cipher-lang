class CipherJS   
  def call(env)
    path = env['REQUEST_PATH']
    case path
    when /.js\s*$/i
      content_type = 'text/javascript'
    else
      content_type = 'text/html'
    end
    content = File.new(File.join(PUBLIC_PATH, path)).read
    [200, {"Content-Type"=> content_type}, content]
  end 
end

RackApp = CipherJS.new