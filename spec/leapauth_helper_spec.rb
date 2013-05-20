require 'spec_helper'

describe LeapauthHelper do
  let(:controller) { DummyController.new }  
  describe ".included class callback" do
    it "sets host constants" do
      expect( "local.leapmotion:3010").to eql LeapauthHelper.auth_host
      expect( "local.leapmotion").to eql LeapauthHelper.auth_domain
      expect( "http://local.leapmotion:3000").to eql LeapauthHelper.home
    end
  end

  describe "#set_auth_cookie_from_user method" do
    before { controller.stub_cookies! }

    context "with valid user" do
      before do
        controller.set_auth_cookie_from_user(double('user', :id => 2, :email => "remi@example.com", :username => 'remi'))
        @cookie = controller.cookie_jar[LeapauthHelper.cookie_auth_key]
      end

      it "sets an authentication cookie" do
        expect( @cookie ).to_not be_nil
        expect( @cookie[:expires] >= 2.weeks.from_now - 1.second).to be_true
      end
    end

    context "with nil user" do
      before { controller.set_auth_cookie_from_user(double('user', :id => 2, :email => "remi@example.com", :username => 'remi')) }

      it "deletes the authentication cookie" do
        controller.set_auth_cookie_from_user(nil)
        expect(controller.cookie_jar[LeapauthHelper.cookie_auth_key]).to be_nil
      end
    end
  end

  describe "#delete_auth_cookie method" do
    before { controller.should_receive(:set_auth_cookie_from_user).with(nil) }
    it("calls set_auth_cookie_from_user with nil") { controller.delete_auth_cookie }
  end

  describe "current_user_from_auth" do
    before { controller.stub_cookies! }

    context "with valid cookie" do
      before do
        controller.set_auth_cookie_from_user(double('user', :id => 2, :email => "remi@example.com", :username => 'remi'))
        @user = controller.current_user_from_auth
      end

      it "returns the authenticated user" do
        expect(@user).to be_an_instance_of(LeapauthHelper::AuthUser)
        expect( "remi@example.com").to eql @user.email
      end
    end

    context "with expired cookie" do
      before do
        controller.stub(:cookie_expiration).and_return(2.days.ago)
        controller.set_auth_cookie_from_user(double('user', :id => 2, :email => "remi@example.com", :username => 'remi'))
        controller.stub(:cookie_expiration).and_return(2.weeks.from_now)
      end

      it "returns nil" do
        expect(controller.cookie_jar[LeapauthHelper.cookie_auth_key]).to_not be_nil # the cookie is really there
        expect(controller.current_user_from_auth).to be_nil
      end
    end

    context "with missing cookie" do
      it { expect(controller.current_user_from_auth).to be_nil }
    end
  end

  describe "#hash_for_user method" do
    before { @user_hash = controller.send(:hash_for_user, mock(:id => 2, :email => "remi@example.com", :username => "remi")) }

    it "returns a hash with user data" do
      expect( "remi@example.com").to eql @user_hash[:email]
      expect(@user_hash[:expires_on] >= (2.weeks.from_now - 1.second).utc.to_i).to be_true
    end
  end

  describe "URL helpers" do
    before { controller.stub(:request).and_return(stub(:protocol => "http://", :host_with_port => "local.leapmotion:4000", :fullpath => "/some-page")) }

    describe "#auth_destroy_session_url method" do
      it "returns the URL" do
        expect( "http://local.leapmotion:3010/users/sign_out?_r=http://local.leapmotion:4000/some-page").to eql controller.send(:auth_destroy_session_url)
      end
    end

    describe "#auth_sign_in_url method" do
      it "returns the URL with a redirect URL" do
        expect( "http://local.leapmotion:3010/users/auth?_r=http://local.leapmotion:4000/some-page").to eql controller.send(:auth_sign_in_url)
      end
    end
  end
end
