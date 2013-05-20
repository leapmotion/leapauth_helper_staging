$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'active_support/all'
require 'leapauth_helper'
require 'mocha/api'
require 'minitest/autorun'

# Custom helpers
Dir[File.expand_path("../test_helpers/*.rb", __FILE__)].each { |f| require f }

class DummyController
  include LeapauthHelper
  include Test::CookieHelper
end

class MiniTest::Unit::TestCase
  include Mocha::API

  class << self
    alias :context :describe
  end

  def controller
    @controller ||= DummyController.new
  end
end
