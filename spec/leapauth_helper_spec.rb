require 'spec_helper'

describe LeapauthHelper do
  let(:controller) { DummyController.new }  
  describe ".included class callback" do
    it "sets host constants" do
      expect( "test.leapmotion:1234").to eql LeapauthHelper.config.auth_host
      expect( "test.leapmotion").to eql LeapauthHelper.config.auth_domain
      expect( "http://test.leapmotion").to eql LeapauthHelper.config.home
    end
  end

  describe "#set_auth_cookie_from_user method" do
    before { controller.stub_cookies! }

    context "with valid user" do
      before do
        controller.set_auth_cookie_from_user(double('user', :id => 2, :email => "remi@example.com", :username => 'remi'))
        @cookie = controller.cookie_jar[LeapauthHelper.config.cookie_auth_key]
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
        expect(controller.cookie_jar[LeapauthHelper.config.cookie_auth_key]).to be_nil
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
        LeapauthHelper::Internal.stub(:cookie_expiration).and_return(2.days.ago)
        controller.set_auth_cookie_from_user(double('user', :id => 2, :email => "remi@example.com", :username => 'remi'))
        controller.stub(:cookie_expiration).and_return(2.weeks.from_now)
      end

      it "returns nil" do
        expect(controller.cookie_jar[LeapauthHelper.config.cookie_auth_key]).to_not be_nil # the cookie is really there
        expect(controller.current_user_from_auth).to be_nil
      end
    end

    context "with missing cookie" do
      it { expect(controller.current_user_from_auth).to be_nil }
    end
  end

  describe 'deprecated methods' do
    describe "#secure_url" do
      it 'warns the caller about deprecation' do
        controller.should_receive(:warn)
        controller.secure_url('/path')
      end
      it 'returns a secured url' do
        expect(controller.secure_url('/path', :query => 'params')).to eql 'http://test.leapmotion:1234/path?query=params'
      end

    end
  end
end
