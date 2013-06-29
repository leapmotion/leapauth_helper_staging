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
      "transactions_host"  =>  "warehouse.leapmotion.com",
      "mixpanel_token"     =>  "77d363605f0470115eb82352f14b2981",
      "google_property_id" =>  "UA-31536531-1"
    },
    'all' => {
      # If you're acme.uservoice.com then this value would be 'acme'.
      "uservoice_subdomain" => "leapbeta",
      # Get this from UserVoice General Settings page: https://leapbeta.uservoice.com/admin/settings
      "uservoice_sso_key"   => "977cc7fa89438e2805111cf01c8cc993",
      # This is our catch-all token for all non-production environments.
      "mixpanel_token"      => "64a624e0f5fd5fec35dff6b08281664e"
    }
  }

  def self.config
    config_data = DEFAULT_CONFIG['all'].merge(DEFAULT_CONFIG[ ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'])
    @@config ||= Config.new(config_data)
  end

  def self.configure
    yield self.config
  end

end
