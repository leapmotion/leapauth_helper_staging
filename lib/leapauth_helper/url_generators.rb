require File.expand_path(File.dirname(__FILE__), "url_helpers")

module LeapauthHelper 
  module UrlGenerators
    #-----------------------------------------------------------------------------------------------
    # Central
    #-----------------------------------------------------------------------------------------------

    def auth_get_user_id_json_url(access_token)
      LeapauthHelper::UrlHelpers.secure_url("/api/whoami", :access_token => access_token)
    end

    def auth_create_session_json_url
      LeapauthHelper::UrlHelpers.secure_url("/users/auth")
    end

    def auth_update_user_json_url(user_id)
      LeapauthHelper::UrlHelpers.secure_url("/api/users/#{user_id}")
    end

    def auth_destroy_session_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/users/sign_out", :_r => destination)
    end
    alias_method :auth_sign_out_url, :auth_destroy_session_url

    def auth_sign_in_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/users/sign_in", :_r => destination)
    end
    alias_method :auth_create_session_url, :auth_sign_in_url 

    def auth_sign_up_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/users/sign_up", :_r => destination)
    end

    def auth_edit_profile_url
      warn "DEPRECATED: Use auth_user_account_url for redirects back to user profile.\nThis method will go away in the future.  Plan accordingly."
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

    def central_reauth_url
      LeapauthHelper::UrlHelpers.secure_url("/users/confirm_password")
    end

    def central_orders_url
      LeapauthHelper::UrlHelpers.secure_url("/orders")
    end

    def central_new_payment_method_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/payment_method/new",  :_r => destination)
    end

    def central_add_airspace_credit_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/account/airspace_credit",  :_r => destination)
    end

    def central_edit_payment_method_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/payment_method/edit", :_r => destination)
    end

    def central_new_billing_address_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/address/new",  :_r => destination)
    end

    def central_sdk_agreement_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/agreements/SdkAgreement", :_r => destination)
    end
    
    def central_root_url
      LeapauthHelper::UrlHelpers.secure_url("/")
    end

    def central_sign_up_or_sign_in_url(destination = current_url)
      LeapauthHelper::UrlHelpers.secure_url("/authenticate", :_r => destination)
    end

    #-----------------------------------------------------------------------------------------------
    # Warehouse
    #-----------------------------------------------------------------------------------------------

    def app_transactions_url
      LeapauthHelper::UrlHelpers.warehouse_url("/api/transactions")
    end

    def app_check_entitlements_url
      LeapauthHelper::UrlHelpers.warehouse_url("/users/check_entitlements")
    end

    def reauth_url
      LeapauthHelper::UrlHelpers.warehouse_url("/users/confirm_password")
    end

    def warehouse_admin_user_url(user)
      LeapauthHelper::UrlHelpers.warehouse_url("/admin/data/users/#{user.id}")
    end

    #-----------------------------------------------------------------------------------------------
    # Airspace
    #-----------------------------------------------------------------------------------------------

    def airspace_root_url
      LeapauthHelper::UrlHelpers.airspace_url("/")
    end

    def airspace_app_url(app_slug)
      LeapauthHelper::UrlHelpers.airspace_url("/apps/#{app_slug}")
    end

    def airspace_promotion_url(cross_promotion_uuid)
      LeapauthHelper::UrlHelpers.airspace_url("/promotions/#{cross_promotion_uuid}")
    end

    def airspace_app_version_preview_url(app_slug, app_version_id)
      LeapauthHelper::UrlHelpers.airspace_url("/apps/#{app_slug}/versions/#{app_version_id}")
    end

    def airspace_web_link_preview_url(web_link_slug)
      LeapauthHelper::UrlHelpers.airspace_url("/links/#{web_link_slug}")
    end

    #-----------------------------------------------------------------------------------------------
    # Home
    #-----------------------------------------------------------------------------------------------

    def home_root_url
      LeapauthHelper::UrlHelpers.home_url("/")
    end

    #-----------------------------------------------------------------------------------------------
    # Developer
    #-----------------------------------------------------------------------------------------------

    def developer_root_url
      LeapauthHelper::UrlHelpers.developer_url("/")
    end

    #-----------------------------------------------------------------------------------------------
    # Etc.
    #-----------------------------------------------------------------------------------------------

    def current_url
      #JR is there a reason we're not using request.url here?
      "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
    end
  end
end
