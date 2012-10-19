require File.expand_path('../test_helper', __FILE__)

describe LeapauthHelper do
  describe ".included class callback" do
    it "sets host constants" do
      assert_equal "local.leapmotion:3000", LeapauthHelper.auth_host
      assert_equal "local.leapmotion", LeapauthHelper.auth_domain
      assert_equal "http://local.leapmotion:3000", LeapauthHelper.home
    end
  end

  describe "#set_auth_cookie_from_user method" do
    before { controller.stub_cookies! }

    context "with valid user" do
      before do
        controller.set_auth_cookie_from_user(stub_everything)
        @cookie = controller.cookie_jar[DummyController::COOKIE_AUTH_KEY]
      end

      it "sets an authentication cookie" do
        refute_nil @cookie
        assert @cookie[:expires] >= 2.weeks.from_now - 1.second
      end
    end

    context "with nil user" do
      before { controller.set_auth_cookie_from_user(stub_everything) }

      it "deletes the authentication cookie" do
        controller.set_auth_cookie_from_user(nil)
        assert_nil controller.cookie_jar[DummyController::COOKIE_AUTH_KEY]
      end
    end
  end

  describe "#delete_auth_cookie method" do
    before { controller.expects(:set_auth_cookie_from_user).with(nil) }
    it("calls set_auth_cookie_from_user with nil") { controller.delete_auth_cookie }
  end

  describe "current_user_from_auth" do
    before { controller.stub_cookies! }

    context "with valid cookie" do
      before do
        controller.set_auth_cookie_from_user(stub_everything(:id => 2, :email => "remi@example.com"))
        @user = controller.current_user_from_auth
      end

      it "returns the authenticated user" do
        assert_instance_of LeapauthHelper::AuthUser, @user
        assert_equal "remi@example.com", @user.email
      end
    end

    context "with expired cookie" do
      before do
        controller.stubs(:cookie_expiration).returns(2.days.ago)
        controller.set_auth_cookie_from_user(stub_everything(:id => 2, :email => "remi@example.com"))
        controller.stubs(:cookie_expiration).returns(2.weeks.from_now)
      end

      it "returns nil" do
        refute_nil controller.cookie_jar[DummyController::COOKIE_AUTH_KEY] # the cookie is really there
        assert_nil controller.current_user_from_auth
      end
    end

    context "with missing cookie" do
      it("returns nil") { assert_nil controller.current_user_from_auth }
    end
  end

  describe "#hash_for_user method" do
    before { @user_hash = controller.send(:hash_for_user, mock(:id => 2, :email => "remi@example.com", :username => "remi")) }

    it "returns a hash with user data" do
      assert_equal "remi@example.com", @user_hash[:email]
      assert @user_hash[:expires_on] >= (2.weeks.from_now - 1.second).utc.to_i
    end
  end

  describe "URL helpers" do
    before { controller.stubs(:request).returns(stub(:protocol => "http://", :host_with_port => "local.leapmotion:4000", :fullpath => "/some-page")) }

    describe "#auth_destroy_session_url method" do
      it "returns the URL with a redirect URL" do
        assert_equal "http://local.leapmotion:3000/users/sign_out?_r=http://local.leapmotion:4000/some-page", controller.send(:auth_destroy_session_url)
      end
    end

    describe "#auth_sign_in_url method" do
      it "returns the URL with a redirect URL" do
        assert_equal "http://local.leapmotion:3000/users/auth?_r=http://local.leapmotion:4000/some-page", controller.send(:auth_sign_in_url)
      end
    end
  end
end
