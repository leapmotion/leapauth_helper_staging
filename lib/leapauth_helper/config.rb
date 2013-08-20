require 'ostruct'

module LeapauthHelper
  class Config < OpenStruct
  end

  # TODO: When we bump the major version, remove the scheme that is hard-coded in the values for the "home" key here.
  DEFAULT_CONFIG = {
    'development' => {
      "auth_host"          => "local.leapmotion:3010",
      "auth_domain"        => "local.leapmotion",
      "home"               => "local.leapmotion:3000",
      "cookie_auth_key"    => "_dev_auth",
      "transactions_host"  => "local.leapmotion:5001",
      "airspace_host"      => "local.leapmotion:5002",
      "developer_host"     => "local.leapmotion:4000"
    },
    'test' => {
      "auth_host"          =>  "test.leapmotion:1234",
      "auth_domain"        =>  "test.leapmotion",
      "home"               =>  "test.leapmotion:3000",
      "cookie_auth_key"    =>  "_test_auth",
      "transactions_host"  =>  "test.leapmotion",
      "airspace_host"      =>  "test.leapmotion",
      "developer_host"     =>  "test.leapmotion"
    },
    'staging' => {
      "auth_host"          =>  "leap:L4!!pStag0ing@central-stage.leapmotion.com",
      "auth_domain"        =>  "leapmotion.com",
      "home"               =>  "leapweb-stage7.herokuapp.com",
      "cookie_auth_key"    =>  "_stage_auth",
      "transactions_host"  =>  "leap:200hands500fingers@warehouse-stage.leapmotion.com",
      "airspace_host"      =>  "leap:h0t$tud10d3v@airspace-staging.leapmotion.com",
      "developer_host"     =>  "leap:L4!!pStag0ing@developer-stage2.leapmotion.com"
    },
    'production' => {
      "auth_host"          =>  "central.leapmotion.com",
      "auth_domain"        =>  "leapmotion.com",
      "home"               =>  "www.leapmotion.com",
      "cookie_auth_key"    =>  "_auth",
      "transactions_host"  =>  "warehouse.leapmotion.com",
      "airspace_host"      =>  "airspace.leapmotion.com",
      "developer_host"     =>  "developer.leapmotion.com",
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
    @@config ||= begin
      cluster_name = ENV['LEAP_CLUSTER_NAME']
      cluster_password = ENV['LEAP_CLUSTER_PASSWORD']
      if cluster_name or cluster_password
        raise "cluster name not in [a-z0-9]{1,20}" unless cluster_name =~ /^[a-z0-9]{1,20}$/
        raise "cluster password not in [0-9a-f]{32,32} (Hint: Use SecureRandom.hex)" unless cluster_password =~ /^[0-9a-f]{32,32}$/
        cluster = {
          "auth_host"          =>  "leap:#{cluster_password}@#{cluster_name}-stage-central.herokuapp.com",
          "home"               =>  "leap:#{cluster_password}@#{cluster_name}-stage-leapweb.herokuapp.com",
          "transactions_host"  =>  "leap:#{cluster_password}@#{cluster_name}-stage-warehouse.herokuapp.com",
          "airspace_host"      =>  "leap:#{cluster_password}@#{cluster_name}-stage-airspace.herokuapp.com",
          "developer_host"     =>  "leap:#{cluster_password}@#{cluster_name}-stage-developer.leapmotion.com",
          "auth_domain"        =>  "herokuapp.com",
          "cookie_auth_key"    =>  "_cluster_auth"
        }
        config_data = DEFAULT_CONFIG['all'].merge(cluster)
      else
        config_data = DEFAULT_CONFIG['all'].merge(DEFAULT_CONFIG[ ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'])
      end
      Config.new(config_data)
    end
  end

  def self.configure
    yield self.config
  end

end
