require 'rubygems'
require 'coffee-script'

ROOT = File.dirname(__FILE__)
PUBLIC_PATH = ROOT + '/public'
COFFEE_PATH = ROOT + '/coffee'
JS_PATH = ROOT + '/public'

# add directories to the load path
$:.unshift "#{ROOT}/components"
$:.unshift "#{ROOT}/lib"

require 'pour_coffee'       # compile modified CoffeeScripts into public directory
require 'cipher_rack_app'   # Rack app, mostly for testing purposes at this point

require File.dirname(__FILE__) + '/lib/cipher.rb'
