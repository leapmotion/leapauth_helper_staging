require "leapauth_helper/version"

module LeapauthHelper
  class << self
    attr_reader :auth_host, :auth_domain
    attr_accessor :home

    def auth_host=(auth_host)
      @auth_host = auth_host
      @auth_domain = auth_host.split(':').first
    end
  end

  def self.included(o)
    raise unless auth_host
    o.class_eval do
      def authenticate_cookie_user!(message = nil)
        redirect_to(auth_sign_in_url, :notice => message) unless current_user_from_auth
      end
    end
  end

  SECRET = "d1J90283!)98Qwc{}[d[d]sq\\e.. .E++1=-qe\\qe.we..ew//s-1=2=3--"
  COOKIE_AUTH_KEY = "_auth"

  def set_top_cookie_from_user(user)
    cookie_present = cookies.key?(COOKIE_AUTH_KEY)
    puts ""
    if user
      val_data = { :id => user.id, :email => user.email, :admin => true }.to_json
      data = "#{hash_for_data(val_data)}/#{val_data}"
      cookies[COOKIE_AUTH_KEY] = {
        :value => data,
        :domain => LeapauthHelper.auth_domain,
        :secure => use_secure?
      }
      !cookie_present
    else
      cookies.delete(COOKIE_AUTH_KEY, :domain => LeapauthHelper.auth_domain)
      cookie_present
    end
  end

  def current_user_from_auth
    unless instance_variable_defined?(:@current_user)
      @current_user ||= begin
        if cookies[COOKIE_AUTH_KEY]
          hash, data = cookies[COOKIE_AUTH_KEY].split('/', 2)
          if hash == hash_for_data(data)
            data = ActiveSupport::JSON.decode(data)
            User.find(data['id'])
          else
            nil
          end
        else
          nil
        end
      end
    end
    @current_user
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
    secure_url("/?r=#{URI.escape(destination)}")
  end

  def auth_edit_profile_url
    secure_url("/users/edit")
  end

  def current_url
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end

  private
  def hash_for_data(d)
    Digest::SHA1.hexdigest(d + SECRET)
  end

  def use_secure?
    %(production staging).include?(Rails.env)
  end

  def secure_url(path, opts = {})
    scheme = use_secure? ? "https" : "http"
    "#{scheme}://#{LeapauthHelper.auth_host}#{path}"
  end
end
