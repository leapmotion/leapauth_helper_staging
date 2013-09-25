require 'cgi'

require "leapauth_helper/config"
require "leapauth_helper/version"
require "leapauth_helper/auth_user"
require "leapauth_helper/google_analytics"
require "leapauth_helper/google_tag_manager"
require "leapauth_helper/mixpanel"
require "leapauth_helper/user_voice"
require "leapauth_helper/user_capabilities"
require "leapauth_helper/url_helpers"
require "leapauth_helper/url_generators"

module LeapauthHelper

  include UrlGenerators

  class Internal
    class << self
      def hash_for_user(user)
        { :id => user.id,
          :email => user.email,
          :expires_on => cookie_expiration.utc.to_i,
          :username => user.username }
      end

      def cookie_expiration
        2.weeks.from_now
      end

      def environment
        ENV["RAILS_ENV"] || ENV["RACK_ENV"]
      end
    end
  end

  class << self
    def auth_host=(auth_host)
      self.configure do |cfg|
        cfg.auth_host = auth_host
        cfg.auth_domain = auth_host.split(':').first
      end
    end
  end

  def self.included(o)
    o.class_eval do
      def authenticate_cookie_user!(message = nil)
        redirect_to(auth_sign_in_url, :notice => message) unless current_user_from_auth
      end
    end
  end

  def delete_auth_cookie
    set_auth_cookie_from_user(nil)
  end

  def set_auth_cookie_from_user(user)
    cookie_present = auth_cookie_jar.key?(LeapauthHelper.config.cookie_auth_key)
    if user
      auth_cookie_jar.signed[LeapauthHelper.config.cookie_auth_key] = {
        :value => Internal.hash_for_user(user).to_json,
        :domain => LeapauthHelper.config.auth_domain,
        :secure => UrlHelpers.use_secure?,
        :expires => Internal.cookie_expiration
      }
      !cookie_present
    else
      auth_cookie_jar.delete(LeapauthHelper.config.cookie_auth_key, :domain => LeapauthHelper.config.auth_domain)
      cookie_present
    end
  end

  def current_user_from_auth
    unless instance_variable_defined?(:@current_user_from_auth)
      @current_user_from_auth ||= begin
        if body = auth_cookie_jar.signed[LeapauthHelper.config.cookie_auth_key]
          data = ActiveSupport::JSON.decode(body)
          LeapauthHelper::AuthUser.new(data)
        else
          warn "your secret_token is not set correctly" if auth_cookie_jar[LeapauthHelper.config.cookie_auth_key]
          nil
        end
      end
    end
    (@current_user_from_auth.nil? || @current_user_from_auth.expired?) ? nil : @current_user_from_auth
  end

  def auth_bar
    text = "Welcome "
    text << "#{link_to "&#9733;".html_safe, "https://#{LeapauthHelper.config.auth_host}/admin"} " if current_user_from_auth.admin?
    text << link_to(current_user_from_auth.email, auth_edit_profile_url)
    text << "! (#{link_to("Logout", auth_destroy_session_url) })"
    if session[:admin_user]
      text << "<br>(impersonated by #{session[:admin_user][:email]})"
    end
    text.html_safe
  end

  def authenticate_auth_user!
    unless current_user_from_auth
      redirect_to auth_sign_in_url
    end
  end

  def auth_cookie_jar
    @auth_cookie_jar || cookies
  end

  def use_auth_cookie_jar(cookie_jar)
    @auth_cookie_jar = cookie_jar
  end

  def secure_url(*args)
    warn "DEPRECATED: You should not be calling secure_url directly.  Instead, please use the url helper methods provided.\nThis method will go away in the future.  Plan accordingly."
    LeapauthHelper::UrlHelpers.secure_url *args
  end

  def home_url(*args)
    LeapauthHelper::UrlHelpers.home_url *args
  end

  def warehouse_url(*args)
    LeapauthHelper::UrlHelpers.warehouse_url *args
  end

end
