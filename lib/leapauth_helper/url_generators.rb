require File.expand_path(File.dirname(__FILE__), "url_helpers")

module LeapauthHelper 
  module UrlGenerators
    #-----------------------------------------------------------------------------------------------
    # Central
    #-----------------------------------------------------------------------------------------------

    def auth_get_user_id_json_url(access_token, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/api/whoami", options.merge(:access_token => access_token))
    end

    def auth_create_session_json_url(options = {})
      LeapauthHelper::UrlHelpers.secure_url("/users/auth", options)
    end

    def auth_update_user_json_url(user_id, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/api/users/#{user_id}", options)
    end

    def auth_destroy_session_url(destination = current_url, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/users/sign_out", options.merge(:_r => destination))
    end
    alias_method :auth_sign_out_url, :auth_destroy_session_url

    def auth_sign_in_url(destination = current_url, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/users/sign_in", options.merge(:_r => destination))
    end
    alias_method :auth_create_session_url, :auth_sign_in_url 

    def auth_sign_up_url(destination = current_url, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/users/sign_up", options.merge(:_r => destination))
    end

    def auth_edit_profile_url(options = {})
      warn "DEPRECATED: Use auth_user_account_url for redirects back to user profile.\nThis method will go away in the future.  Plan accordingly."
      LeapauthHelper::UrlHelpers.secure_url("/users/edit", options)
    end

    def auth_forgot_password_url(options = {})
      LeapauthHelper::UrlHelpers.secure_url("/users/password/new", options)
    end

    def auth_require_username_url(options = {})
      LeapauthHelper::UrlHelpers.secure_url("/users/developer", options)
    end

    def auth_revert_to_admin_url(options = {})
      LeapauthHelper::UrlHelpers.secure_url("/revert", options)
    end

    def auth_admin_users_url(options = {})
      LeapauthHelper::UrlHelpers.secure_url("/admin/users", options)
    end

    def auth_admin_user_url(user_id, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/admin/users/#{user_id}", options)
    end

    def auth_admin_user_edit_embed_url(user_id, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/admin/users/#{user_id}/edit_embed", options)
    end

    def auth_user_account_url(options = {})
      LeapauthHelper::UrlHelpers.secure_url("/account", options)
    end

    def central_reauth_url(options = {})
      LeapauthHelper::UrlHelpers.secure_url("/users/confirm_password", options)
    end

    def central_orders_url(options = {})
      LeapauthHelper::UrlHelpers.secure_url("/orders", options)
    end

    def central_new_payment_method_url(destination = current_url, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/payment_method/new", options.merge(:_r => destination))
    end

    def central_add_airspace_credit_url(destination = current_url, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/account/airspace_credit", options.merge(:_r => destination))
    end

    def central_add_app_store_credit_url(destination = current_url, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/account/airspace_credit", options.merge(:_r => destination))
    end

    def central_edit_payment_method_url(destination = current_url, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/payment_method/edit", options.merge(:_r => destination))
    end

    def central_new_billing_address_url(destination = current_url, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/address/new", options.merge(:_r => destination))
    end

    def central_sdk_agreement_url(destination = current_url, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/agreements/SdkAgreement", options.merge(:_r => destination))
    end
    
    def central_root_url(options = {})
      LeapauthHelper::UrlHelpers.secure_url("/", options)
    end

    def central_sign_up_or_sign_in_url(destination = current_url, options = {})
      LeapauthHelper::UrlHelpers.secure_url("/authenticate", options.merge(:_r => destination))
    end

    #-----------------------------------------------------------------------------------------------
    # Warehouse
    #-----------------------------------------------------------------------------------------------

    def app_transactions_url(options = {})
      LeapauthHelper::UrlHelpers.warehouse_url("/api/transactions", options)
    end

    def app_check_entitlements_url(options = {})
      LeapauthHelper::UrlHelpers.warehouse_url("/users/check_entitlements", options)
    end

    def reauth_url(options = {})
      LeapauthHelper::UrlHelpers.warehouse_url("/users/confirm_password", options)
    end

    def warehouse_admin_user_url(user, options = {})
      LeapauthHelper::UrlHelpers.warehouse_url("/admin/data/users/#{user.id}", options)
    end

    #-----------------------------------------------------------------------------------------------
    # Airspace
    #-----------------------------------------------------------------------------------------------

    def airspace_root_url(options = {})
      LeapauthHelper::UrlHelpers.airspace_url("/", options)
    end

    def app_store_root_url(options = {})
      LeapauthHelper::UrlHelpers.app_store_url("/", options)
    end

    def airspace_app_url(app_slug, options = {})
      LeapauthHelper::UrlHelpers.airspace_url("/apps/#{app_slug}", options)
    end

    def app_store_app_url(app_slug, options = {})
      LeapauthHelper::UrlHelpers.app_store_url("/apps/#{app_slug}", options)
    end

    def airspace_promotion_url(cross_promotion_uuid, options = {})
      LeapauthHelper::UrlHelpers.airspace_url("/promotions/#{cross_promotion_uuid}", options)
    end

    def app_store_promotion_url(cross_promotion_uuid, options = {})
      LeapauthHelper::UrlHelpers.app_store_url("/promotions/#{cross_promotion_uuid}", options)
    end

    def airspace_app_version_preview_url(app_slug, app_version_id, options = {})
      LeapauthHelper::UrlHelpers.airspace_url("/apps/#{app_slug}/versions/#{app_version_id}", options)
    end

    def app_store_app_version_preview_url(app_slug, app_version_id, options = {})
      LeapauthHelper::UrlHelpers.app_store_url("/apps/#{app_slug}/versions/#{app_version_id}", options)
    end

    def airspace_web_link_preview_url(web_link_slug, options = {})
      LeapauthHelper::UrlHelpers.airspace_url("/links/#{web_link_slug}", options)
    end

    def app_store_web_link_preview_url(web_link_slug, options = {})
      LeapauthHelper::UrlHelpers.app_store_url("/links/#{web_link_slug}", options)
    end

    #-----------------------------------------------------------------------------------------------
    # Home
    #-----------------------------------------------------------------------------------------------

    def home_root_url(options = {})
      LeapauthHelper::UrlHelpers.home_url("/", options)
    end

    #-----------------------------------------------------------------------------------------------
    # Developer
    #-----------------------------------------------------------------------------------------------

    def developer_root_url(options = {})
      LeapauthHelper::UrlHelpers.developer_url("/", options)
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
