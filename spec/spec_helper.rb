require 'rubygems'
require 'rack'      # only kicked up for the testing environment
require 'rack/utils'
require 'rack/test'
require 'rspec'
require 'capybara/rspec'
require 'capybara-webkit'

require File.join(File.dirname(__FILE__), '..', 'boot.rb')

# require all of the helper files
# Dir.glob("#{File.dirname(__FILE__)}/helpers/*.rb").each { |file| require file }

TEST_JAVASCRIPT = false unless defined?(TEST_JAVASCRIPT)
if TEST_JAVASCRIPT
  puts "RUNNING JAVASCRIPT TESTS ONLY"
  require File.dirname(__FILE__) + '/js_helper.rb'
else
  puts "RUNNING RUBY TESTS ONLY"
end

include Capybara::DSL
Capybara.app = RackApp

RSpec.configure do |conf|
  if TEST_JAVASCRIPT
    conf.filter_run_excluding :ruby_only => true
  else

    conf.filter_run_excluding :js_only => true
  end
  conf.include Rack::Test::Methods
  conf.before(:each) do
    if TEST_JAVASCRIPT
      visit '/index.html'
    end
    def language
      Capybara.current_driver == :webkit ? :javascript : :ruby
    end
  end
end
