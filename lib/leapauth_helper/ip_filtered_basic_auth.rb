require 'rack'

module LeapauthHelper
  class IpFilteredBasicAuth < Rack::Auth::Basic
    def initialize(app, realm='Restricted Area', &block)
      if block_given?
        super
      else
        super do |username, password|
          [username, password] == ['leap', (ENV['LEAP_CLUSTER_PASSWORD'] || 'L4!!pStag0ing')]
        end
      end
    end
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