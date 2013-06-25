require 'spec_helper'

describe LeapauthHelper::UrlGenerators do
  let(:controller) { DummyController.new }  
  before do
    controller.stub :request => stub(:protocol => "http://", 
                                     :host_with_port => "local.leapmotion:4000", 
                                     :fullpath => "/some-page")
  end
  
  describe "#auth_destroy_session_url method" do
    it "returns the URL" do
      expect( "http://#{LeapauthHelper.config.auth_host}/users/sign_out?_r=http%3A%2F%2Flocal.leapmotion%3A4000%2Fsome-page").to eql controller.auth_destroy_session_url
    end
  end
  
  describe "#auth_sign_out_url method" do
    it "returns the URL" do
      expect( "http://#{LeapauthHelper.config.auth_host}/users/sign_out?_r=http%3A%2F%2Flocal.leapmotion%3A4000%2Fsome-page").to eql controller.auth_sign_out_url
    end
  end
  
  describe "#auth_sign_in_url method" do
    it "returns the URL with a redirect URL" do
      expect( "http://#{LeapauthHelper.config.auth_host}/users/sign_in?_r=http%3A%2F%2Flocal.leapmotion%3A4000%2Fsome-page").to eql controller.auth_sign_in_url
    end
  end
  
  describe "#auth_create_session_url method" do
    it "returns the URL with a redirect URL" do
      expect( "http://#{LeapauthHelper.config.auth_host}/users/sign_in?_r=http%3A%2F%2Flocal.leapmotion%3A4000%2Fsome-page").to eql controller.auth_create_session_url
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
end
