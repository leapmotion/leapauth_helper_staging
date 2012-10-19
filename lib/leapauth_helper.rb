require "leapauth_helper/version"
require "leapauth_helper/auth_user"

module LeapauthHelper
  class << self
    attr_accessor :home, :auth_domain, :auth_host

    def auth_host=(auth_host)
      @auth_host = auth_host
      @auth_domain = auth_host.split(':').first
    end
  end

  def self.included(o)
    case Rails.env
    when 'development'
      LeapauthHelper.auth_host = "local.leapmotion:3000"
      LeapauthHelper.auth_domain = "local.leapmotion"
      LeapauthHelper.home = "http://local.leapmotion:3000"
    when 'test'
      # who knows?
    when 'staging'
      LeapauthHelper.auth_host = "stage.leapmotion.com"
      LeapauthHelper.auth_domain = ".stage.leapmotion.com"
      LeapauthHelper.home = "https://stage.leapmotion.com"
    when 'production'
      LeapauthHelper.auth_host = "leapmotion.com"
      LeapauthHelper.auth_domain = ".leapmotion.com"
      LeapauthHelper.home = "https://leapmotion.com"
    end

    o.class_eval do
      def authenticate_cookie_user!(message = nil)
        redirect_to(auth_sign_in_url, :notice => message) unless current_user_from_auth
      end
    end
  end

  SECRET = "d1J90283!)98Qwc{}[d[d]sq\\e.. .E++1=-qe\\qe.we..ew//s-1=2=3--"
  COOKIE_AUTH_KEY = "_auth"
  ENCRYPTOR = ActiveSupport::MessageEncryptor.new(SECRET)

  def delete_auth_cookie
    set_auth_cookie_from_user(nil)
  end

  def set_auth_cookie_from_user(user)
    cookie_present = cookies.key?(COOKIE_AUTH_KEY)
    if user
      cookies[COOKIE_AUTH_KEY] = {
        :value => ENCRYPTOR.encrypt_and_sign(hash_for_user(user).to_json),
        :domain => LeapauthHelper.auth_domain,
        :secure => use_secure?,
        :expires => cookie_expiration
      }
      !cookie_present
    else
      cookies.delete(COOKIE_AUTH_KEY, :domain => LeapauthHelper.auth_domain)
      cookie_present
    end
  end

  def current_user_from_auth
    unless instance_variable_defined?(:@current_user_from_auth)
      @current_user_from_auth ||= begin
        if cookies[COOKIE_AUTH_KEY]
          data = ActiveSupport::JSON.decode(ENCRYPTOR.decrypt_and_verify(cookies[COOKIE_AUTH_KEY]))
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
    text << "#{link_to "&#9733;".html_safe, "https://www.#{LeapauthHelper.auth_host}/admin"} " if current_user_from_auth.admin?
    text << link_to(current_user_from_auth.email, auth_edit_profile_url)
    text << "! (#{link_to("Logout", auth_destroy_session_url) })"
    if session[:admin_user]
      text << "<br>(impersonated by #{session[:admin_user][:email]})"
    end
    text.html_safe
  end

  def auth_destroy_session_url(destination = current_url)
    secure_url("/users/sign_out?r=#{URI.escape(destination)}")
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

  private
  def hash_for_user(user)
    { :id => user.id,
      :email => user.email,
      :expires_on => cookie_expiration.utc.to_i,
      :username => user.username }
  end

  def cookie_expiration
    2.minutes.from_now
  end

  def use_secure?
    %(production staging).include?(Rails.env)
  end

  def secure_url(path, opts = {})
    scheme = use_secure? ? "https" : "http"
    "#{scheme}://#{LeapauthHelper.auth_host}#{path}"
  end
end
