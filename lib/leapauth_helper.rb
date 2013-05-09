require 'cgi'

require "leapauth_helper/version"
require "leapauth_helper/auth_user"
require "leapauth_helper/user_capabilities"

module LeapauthHelper
  class << self
    attr_accessor :home, :auth_domain, :auth_host, :cookie_auth_key

    def auth_host=(auth_host)
      @auth_host = auth_host
      @auth_domain = auth_host.split(':').first
    end
  end

  def self.included(o)
    case Rails.env
    when 'development'
      LeapauthHelper.auth_host = "local.leapmotion:3010"
      LeapauthHelper.auth_domain = "local.leapmotion"
      LeapauthHelper.home = "http://local.leapmotion:3000"
      LeapauthHelper.cookie_auth_key = "_dev_auth"
    when 'test'
      LeapauthHelper.auth_host = "test.leapmotion"
      LeapauthHelper.auth_domain = "test.leapmotion"
      LeapauthHelper.home = "http://test.leapmotion"
      LeapauthHelper.cookie_auth_key = "_test_auth"
    when 'staging'
      LeapauthHelper.auth_host = "central-stage.leapmotion.com"
      LeapauthHelper.auth_domain = "leapmotion.com"
      LeapauthHelper.home = "http://leapweb-stage7.herokuapp.com"
      LeapauthHelper.cookie_auth_key = "_stage_auth"
    when 'production'
      LeapauthHelper.auth_host = "central.leapmotion.com"
      LeapauthHelper.auth_domain = "leapmotion.com"
      LeapauthHelper.home = "https://www.leapmotion.com"
      LeapauthHelper.cookie_auth_key = "_auth"
    end

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
    cookie_present = auth_cookie_jar.key?(LeapauthHelper.cookie_auth_key)
    if user
      auth_cookie_jar.signed[LeapauthHelper.cookie_auth_key] = {
        :value => hash_for_user(user).to_json,
        :domain => LeapauthHelper.auth_domain,
        :secure => use_secure?,
        :expires => cookie_expiration
      }
      !cookie_present
    else
      auth_cookie_jar.delete(LeapauthHelper.cookie_auth_key, :domain => LeapauthHelper.auth_domain)
      cookie_present
    end
  end

  def current_user_from_auth
    unless instance_variable_defined?(:@current_user_from_auth)
      @current_user_from_auth ||= begin
        if body = auth_cookie_jar.signed[LeapauthHelper.cookie_auth_key]
          data = ActiveSupport::JSON.decode(body)
          LeapauthHelper::AuthUser.new(data)
        else
          nil
        end
      end
    end
    (@current_user_from_auth.nil? || @current_user_from_auth.expired?) ? nil : @current_user_from_auth
  end

  def auth_bar
    text = "Welcome "
    text << "#{link_to "&#9733;".html_safe, "https://#{LeapauthHelper.auth_host}/admin"} " if current_user_from_auth.admin?
    text << link_to(current_user_from_auth.email, auth_edit_profile_url)
    text << "! (#{link_to("Logout", auth_destroy_session_url) })"
    if session[:admin_user]
      text << "<br>(impersonated by #{session[:admin_user][:email]})"
    end
    text.html_safe
  end

  def auth_create_session_json_url
    secure_url("/users/auth")
  end

  def auth_update_user_json_url(user_id)
    secure_url("/api/users/#{user_id}")
  end

  def auth_destroy_session_url(destination = current_url)
    secure_url("/users/sign_out?_r=#{URI.escape(destination)}")
  end

  def auth_sign_in_url(destination = current_url)
    secure_url("/users/auth?_r=#{URI.escape(destination)}")
  end

  def auth_edit_profile_url
    secure_url("/users/edit")
  end

  def current_url
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
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

  private
  def hash_for_user(user)
    { :id => user.id,
      :email => user.email,
      :expires_on => cookie_expiration.utc.to_i,
      :username => user.username }
  end

  def cookie_expiration
    2.weeks.from_now
  end

  def use_secure?
    %(production).include?(Rails.env)
  end

  def secure_url(path, opts = {})
    scheme = use_secure? ? "https" : "http"
    url = "#{scheme}://#{LeapauthHelper.auth_host}#{path}"
    opts.empty? ? url : "#{url}?#{Rack::Utils.build_query(opts)}"
  end
end
