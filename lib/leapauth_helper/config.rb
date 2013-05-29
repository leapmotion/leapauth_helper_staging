require 'ostruct'

module LeapauthHelper
  class Config < OpenStruct
  end
  
  DEFAULT_CONFIG = {
    'development' => {
      "auth_host"          => "local.leapmotion:3010",
      "auth_domain"        => "local.leapmotion",
      "home"               => "http://local.leapmotion:3000",
      "cookie_auth_key"    => "_dev_auth",
      "transactions_host"  => "local.leapmotion:5001"
    },
    'test' => {
      "auth_host"          =>  "test.leapmotion:1234",
      "auth_domain"        =>  "test.leapmotion",
      "home"               =>  "http://test.leapmotion",
      "cookie_auth_key"    =>  "_test_auth",
      "transactions_host"  =>  "test.leapmotion"
    },
    'staging' => {
      "auth_host"          =>  "central-stage.leapmotion.com",       
      "auth_domain"        =>  "leapmotion.com",                     
      "home"               =>  "http://leapweb-stage7.herokuapp.com",
      "cookie_auth_key"    =>  "_stage_auth",                        
      "transactions_host"  =>  "warehouse-stage.leapmotion.com"     
    },
    'production' => {
      "auth_host"          =>  "central.leapmotion.com",
      "auth_domain"        =>  "leapmotion.com",
      "home"               =>  "https://www.leapmotion.com",
      "cookie_auth_key"    =>  "_auth",
      "transactions_host"  =>  "warehouse.leapmotion.com"
    }
  }

  def self.config
    @@config ||= Config.new(DEFAULT_CONFIG[ ENV['RAILS_ENV'] ])
  end

  def self.configure
    yield self.config
  end


end
