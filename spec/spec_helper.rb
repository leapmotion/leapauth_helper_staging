$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])


require 'active_support/all'
require 'leapauth_helper'

Dir[File.join(File.dirname(__FILE__), "..", "spec/support/**/*.rb")].each {|f| require f}

class DummyController
  include LeapauthHelper
  include Test::CookieHelper
end
