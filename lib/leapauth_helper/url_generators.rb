require File.expand_path(File.dirname(__FILE__), "url_helpers")

module LeapauthHelper
 
  module UrlGenerators
    
    def auth_get_user_id_json_url
      LeapauthHelper::UrlHelpers.secure_url("/api/whoami")
    end

    def auth_create_session_json_url
      LeapauthHelper::UrlHelpers.secure_url("/users/auth")
    end

    def auth_update_user_json_url(user_id)
      LeapauthHelper::UrlHelpers.secure_url("/api/users/#{user_id}")
    end

    def auth_destroy_session_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/users/sign_out?_r=#{URI.escape(destination)}")
    end
    alias_method :auth_sign_out_url, :auth_destroy_session_url

    def auth_sign_in_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/users/auth?_r=#{URI.escape(destination)}")
    end
    alias_method :auth_create_session_url, :auth_sign_in_url 

    def auth_edit_profile_url
      LeapauthHelper::UrlHelpers.secure_url("/users/edit")
    end

    def auth_forgot_password_url
      LeapauthHelper::UrlHelpers.secure_url("/users/password/new")
    end

    def auth_require_username_url
      LeapauthHelper::UrlHelpers.secure_url("/users/developer")
    end

    def auth_revert_to_admin_url
      LeapauthHelper::UrlHelpers.secure_url("/revert")
    end

    def auth_admin_users_url
      LeapauthHelper::UrlHelpers.secure_url("/admin/users")
    end

    def auth_admin_user_url(user_id)
      LeapauthHelper::UrlHelpers.secure_url("/admin/users/#{user_id}")
    end

    def current_url
      #JR is there a reason we're not using request.url here?
      "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
    end

    def transactions_url
      scheme = LeapauthHelper::UrlHelpers.use_secure_transactions? ? "https" : "http"
      "#{scheme}://#{LeapauthHelper.config.transactions_host}/api/transactions"
    end

  end
end
