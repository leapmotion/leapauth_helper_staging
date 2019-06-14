require 'ostruct'

module LeapauthHelper
  class Config < OpenStruct
  end

  MAGIC_STRING_TO_DISABLE_CLUSTER_PASSWORDS = "THIS_CLUSTER_HAS_NO_PASSWORD"

  DEFAULT_CONFIG = {
    'development' => {
      "auth_host"          => ENV['OVERRIDE_AUTH_HOST'].try(:[], %r{//(.*)}, 1) || "local.leapmotion:3010",
      "auth_domain"        => ENV['OVERRIDE_AUTH_HOST'].try(:[], %r{//(.*?)(:[0-9]+)?\z}, 1) || "local.leapmotion",
      "home"               => "local.leapmotion:3000",
      "cookie_auth_key"    => "_dev_auth",
      "transactions_host"  => "local.leapmotion:5001",
      "airspace_host"      => "local.leapmotion:5002",
      "app_store_host"     => "local.leapmotion:5002",
      "community_host"     => "local.leapmotion:5000",
      "developer_host"     => "local.leapmotion:4000"
    },
    'test' => {
      "auth_host"          =>  "test.leapmotion:1234",
      "auth_domain"        =>  "test.leapmotion",
      "home"               =>  "test.leapmotion:3000",
      "cookie_auth_key"    =>  "_test_auth",
      "transactions_host"  =>  "test.leapmotion",
      "airspace_host"      =>  "test.leapmotion",
      "app_store_host"     =>  "test.leapmotion",
      "community_host"     =>  "test.leapmotion",
      "developer_host"     =>  "test.leapmotion"
    },
    'staging' => {
      "auth_host"          =>  "leap:L4!!pStag0ing@central-stage.leapmotion.com",
      "auth_domain"        =>  "leapmotion.com",
      "home"               =>  "leapweb-stage7.herokuapp.com",
      "cookie_auth_key"    =>  "_stage_auth",
      "transactions_host"  =>  "leap:200hands500fingers@warehouse-stage.leapmotion.com",
      "airspace_host"      =>  "leap:h0t$tud10d3v@airspace-staging.leapmotion.com",
      "app_store_host"     =>  "leap:h0t$tud10d3v@app-home-staging.leapmotion.com",
      "community_host"     =>  "leap:h0t$tud10d3v@community-staging.leapmotion.com",
      "developer_host"     =>  "leap:L4!!pStag0ing@developer-stage2.leapmotion.com"
    },
    'production' => {
      "auth_host"          =>  "central.leapmotion.com",
      "auth_domain"        =>  "leapmotion.com",
      "home"               =>  "www.leapmotion.com",
      "cookie_auth_key"    =>  "_auth",
      "transactions_host"  =>  "warehouse.leapmotion.com",
      "airspace_host"      =>  "airspace.leapmotion.com",
      "app_store_host"     =>  "apps.leapmotion.com",
      "community_host"     =>  "community.leapmotion.com",
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
      "mixpanel_token"      => "64a624e0f5fd5fec35dff6b08281664e",
      # Apps will need to access this in their config/staging.rb, so we'll stuff it into the Config ostruct.
      "magic_string_to_disable_cluster_passwords" => MAGIC_STRING_TO_DISABLE_CLUSTER_PASSWORDS,
      "leap_motion_ips" => [
        '173.247.193.180', # Leap Motion office at 333 Bryant St. Added Oct 29th
        '4.35.164.34', # Leap Motion office at 321 11th St
      ],
      # Allows user to make purchases on Airspace, set by Central via Signing In/Out or the Confirm Password dialog
      "cookie_purchase_key"=>  "can_purchase",
      # Airspace Home auth key for launching DRM apps, delete after signing out.
      "cookie_desktop_auth_key"=>  "_desktop_auth"
    }
  }

  def self.config
    @@config ||= begin
      cluster_name     = ENV['LEAP_CLUSTER_NAME']
      cluster_password = ENV['LEAP_CLUSTER_PASSWORD']
      if cluster_name || cluster_password
        raise "cluster name not in [a-z0-9\-]{1,15}" unless cluster_name =~ /^[a-z0-9\-]{1,15}$/
        raise "cluster password not in [0-9a-f]{32,32} (hint: use SecureRandom.hex(16))" unless (cluster_password =~ /^[0-9a-f]{32,32}$/ || cluster_password == MAGIC_STRING_TO_DISABLE_CLUSTER_PASSWORDS)

        cluster_apps = {
          "auth_host"         =>  "central",
          "community_host"    =>  "community",
          "home"              =>  "leapweb",
          "transactions_host" =>  "warehouse",
          "airspace_host"     =>  "airspace",
          "app_store_host"    =>  "apps",
          "developer_host"    =>  "leapdev"
        }

        # Heroku allows a max of 30 characters for the name, so let's leave the boilerplate as short as possible.
        # The below approach allows for a max cluster_name length of 15 characters (because "lm-s-warehouse-".length == 15).
        cluster_apps.each do |k, v|
          if cluster_password == MAGIC_STRING_TO_DISABLE_CLUSTER_PASSWORDS
            cluster_apps[k] = "lm-s-#{v}-#{cluster_name}.leapmotion.com"
          else
            cluster_apps[k] = "leap:#{cluster_password}@lm-s-#{v}-#{cluster_name}.leapmotion.com"
          end
        end

        cluster_defaults = {
          "auth_domain"        =>  "leapmotion.com",
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
