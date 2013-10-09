require 'ostruct'

module LeapauthHelper
  class Config < OpenStruct
  end

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
      "google_property_id" =>  "UA-31536531-1",
      "gtm_container_id"   =>  "GTM-WXGVFM"
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
      cluster_name     = ENV['LEAP_CLUSTER_NAME']
      cluster_password = ENV['LEAP_CLUSTER_PASSWORD']
      if cluster_name || cluster_password
        raise "cluster name not in [a-z0-9]{1,15}" unless cluster_name =~ /^[a-z0-9]{1,15}$/
        raise "cluster password not in [0-9a-f]{32,32} (hint: use SecureRandom.hex(16))" unless cluster_password =~ /^[0-9a-f]{32,32}$/

        cluster_apps = {
          "auth_host"         =>  "central",
          "home"              =>  "leapweb",
          "transactions_host" =>  "warehouse",
          "airspace_host"     =>  "airspace",
          "developer_host"    =>  "developer"
        }

        # Heroku allows a max of 30 characters for the name, so let's leave the boilerplate as short as possible.
        # The below approach allows for a max cluster_name length of 15 characters (because "lm-s-warehouse-".length == 15).
        cluster_apps.each do |k, v|
          cluster_apps[k] = "leap:#{cluster_password}@lm-s-#{v}-#{cluster_name}.herokuapp.com"
        end

        cluster_defaults = {
          "auth_domain"        =>  "herokuapp.com",
          "cookie_auth_key"    =>  "_lm_cluster_#{cluster_name}_auth"
        }

        cluster = cluster_apps.merge(cluster_defaults)
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
