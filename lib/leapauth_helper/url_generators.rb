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
      LeapauthHelper::UrlHelpers.secure_url("/users/sign_out?_r=#{CGI.escape(destination)}")
    end
    alias_method :auth_sign_out_url, :auth_destroy_session_url

    def auth_sign_in_url(destination = current_url)
      scheme = LeapauthHelper::UrlHelpers.use_secure_transactions? ? "https" : "http"
      "#{scheme}://#{LeapauthHelper.config.auth_host}/users/sign_in?_r=#{CGI.escape(destination)}"
    end
    alias_method :auth_create_session_url, :auth_sign_in_url 

    def auth_sign_up_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/users/sign_up?_r=#{CGI.escape(destination)}")
    end

    def auth_edit_profile_url
      warn "DEPRECATED: Use auth_user_account_url for redirects back to user profile.\nThis method will go away in the future.  Plan accordingly"
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

    def auth_admin_user_edit_embed_url(user_id)
      LeapauthHelper::UrlHelpers.secure_url("/admin/users/#{user_id}/edit_embed")
    end

    def auth_user_account_url()
      LeapauthHelper::UrlHelpers.secure_url("/account")
    end

    def current_url
      #JR is there a reason we're not using request.url here?
      "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
    end

    def app_transactions_url
      scheme = LeapauthHelper::UrlHelpers.use_secure_transactions? ? "https" : "http"
      "#{scheme}://#{LeapauthHelper.config.transactions_host}/api/transactions"
    end

    def reauth_url
      scheme = LeapauthHelper::UrlHelpers.use_secure_transactions? ? "https" : "http"
      "#{scheme}://#{LeapauthHelper.config.transactions_host}/users/confirm_password"
    end

    def airspace_root_url
      scheme = LeapauthHelper::UrlHelpers.use_secure_transactions? ? "https" : "http"
      "#{scheme}://#{LeapauthHelper.config.airspace_host}"
    end

    def central_reauth_url
      LeapauthHelper::UrlHelpers.secure_url("/users/confirm_password")
    end

    def central_orders_url
      LeapauthHelper::UrlHelpers.secure_url("/orders")
    end

    def central_new_payment_method_url(destination = current_url)
      scheme = LeapauthHelper::UrlHelpers.use_secure_transactions? ? "https" : "http"
      "#{scheme}://#{LeapauthHelper.config.auth_host}/payment_method/new?_r=#{CGI.escape(destination)}"
    end

    def central_edit_payment_method_url(destination = current_url)
      scheme = LeapauthHelper::UrlHelpers.use_secure_transactions? ? "https" : "http"
      "#{scheme}://#{LeapauthHelper.config.auth_host}/payment_method/edit?_r=#{CGI.escape(destination)}"
    end

  end
end
