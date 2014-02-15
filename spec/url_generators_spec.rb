require 'spec_helper'

describe LeapauthHelper::UrlGenerators do
  let(:controller) { DummyController.new }
  let(:expected_redirect){ CGI.escape('http://local.leapmotion:4000/some-page?a=1&b=2') }
  before do
    controller.stub :request => stub(:protocol => "http://",
                                     :host_with_port => "local.leapmotion:4000",
                                     :fullpath => "/some-page?a=1&b=2")

  end

  describe "#auth_destroy_session_url method" do
    it "returns the URL" do
      expect( "http://#{LeapauthHelper.config.auth_host}/users/sign_out?_r=#{expected_redirect}").to eql controller.auth_destroy_session_url
    end
  end

  describe "#auth_sign_out_url method" do
    it "returns the URL" do
      expect( "http://#{LeapauthHelper.config.auth_host}/users/sign_out?_r=#{expected_redirect}").to eql controller.auth_sign_out_url
    end
  end

  describe "#auth_sign_up_url method" do
    it "returns the URL to sign up with a redirect" do
      expect( "http://#{LeapauthHelper.config.auth_host}/users/sign_up?_r=#{expected_redirect}").to eql controller.auth_sign_up_url
    end
  end

  describe "#auth_sign_in_url method" do
    it "returns the URL with a redirect URL" do
      expect( "http://#{LeapauthHelper.config.auth_host}/users/sign_in?_r=#{expected_redirect}").to eql controller.auth_sign_in_url
    end
  end

  describe "#auth_create_session_url method" do
    it "returns the URL with a redirect URL" do
      expect( "http://#{LeapauthHelper.config.auth_host}/users/sign_in?_r=#{expected_redirect}").to eql controller.auth_create_session_url
    end
  end

  describe "#auth_admin_users_url method" do
    it "returns the URL to the admin users index page" do
      expect( "http://#{LeapauthHelper.config.auth_host}/admin/users").to eql controller.auth_admin_users_url
    end
  end

  describe "#auth_admin_user_url method" do
    it "returns the URL to the admin view of a specific user page" do
      expect( "http://#{LeapauthHelper.config.auth_host}/admin/users/202").to eql controller.auth_admin_user_url(202)
    end
  end

  describe "#auth_user_account_url method" do
    it "returns the URL to the account page" do
      expect( "http://#{LeapauthHelper.config.auth_host}/account").to eql controller.auth_user_account_url
    end
  end

  describe "#auth_forgot_password_url" do
    it {
      expect(controller.auth_forgot_password_url).to eql "http://#{LeapauthHelper.config.auth_host}/users/password/new"
    }
  end

  describe '#auth_require_username_url' do
    it {
      expect(controller.auth_require_username_url).to eql "http://#{LeapauthHelper.config.auth_host}/users/developer"
    }
  end

  describe '#auth_require_username_url' do
    it {
      expect(controller.auth_admin_user_edit_embed_url(1313)).to eql "http://#{LeapauthHelper.config.auth_host}/admin/users/1313/edit_embed"
    }
  end

  describe "#central_sdk_agreement_url" do
    it { expect("http://#{LeapauthHelper.config.auth_host}/agreements/SdkAgreement?_r=#{expected_redirect}").to eql controller.central_sdk_agreement_url }
  end

  describe "#central_sdk_agreement_url with explicit nil for redirection param" do
    it { expect("http://#{LeapauthHelper.config.auth_host}/agreements/SdkAgreement").to eql controller.central_sdk_agreement_url(nil) }
  end

  describe '#central_sign_up_or_sign_in_url' do
    it { expect("http://#{LeapauthHelper.config.auth_host}/authenticate?_r=#{expected_redirect}").to eql controller.central_sign_up_or_sign_in_url }
  end
end
