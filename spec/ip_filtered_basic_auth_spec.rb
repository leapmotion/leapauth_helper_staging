require 'spec_helper'

describe LeapauthHelper::IpFilteredBasicAuth do
  let(:app) { ->(env) { [200, env, "app"] } }

  describe 'authenticating a request' do
    before do
      ENV['LEAP_CLUSTER_PASSWORD'] = 'df89sdg9sdg'
    end

    it "provides access from LM office without password" do
      mw = LeapauthHelper::IpFilteredBasicAuth.new(app)
      code, env = mw.call env_for("https://youhost.leapmotion.com", 'REMOTE_ADDR' => LeapauthHelper.config.leap_motion_ips.first)
      expect(code).to eq 200
    end

    it "provides access from no IP with a password" do
      pending
      mw = LeapauthHelper::IpFilteredBasicAuth.new app, 'raimo' do |u,p|
        [u,p] == ['leap', ENV['LEAP_CLUSTER_PASSWORD']]
      end
      code, env = mw.call(env_for("https://leap:#{ENV['LEAP_CLUSTER_PASSWORD']}@youhost.leapmotion.com"))
      expect(code).to eq 200
    end

    it "denies access with no IP or a password" do
      mw = LeapauthHelper::IpFilteredBasicAuth.new(app)
      code, env = mw.call env_for("https://youhost.leapmotion.com")
      expect(code).to eq 401
    end
  end


  def env_for url, opts={}
    Rack::MockRequest.env_for(url, opts)
  end
end