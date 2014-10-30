require 'rack'

module LeapauthHelper
  class IpFilteredBasicAuth < Rack::Auth::Basic
    def call(env)
      request = Rack::Request.new(env)
      if LeapauthHelper.config.leap_motion_ips.include?(request.ip) || ENV['LEAP_CLUSTER_PASSWORD'] == LeapauthHelper.config.magic_string_to_disable_cluster_passwords
        @app.call(env)  # skip auth
      else
        super           # perform auth
      end
    end
  end
end