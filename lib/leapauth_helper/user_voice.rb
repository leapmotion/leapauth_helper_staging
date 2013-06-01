require 'ezcrypto'

module LeapauthHelper
  module UserVoice
    # For details on UserVoice SSO, see: https://developer.uservoice.com/docs/site/single-sign-on/
    def generate_uservoice_token(user_id, email, display_name)
      # If we don't have enough user info, bail.
      raise "Must pass User ID, email, and display name to generate a UserVoice SSO token." unless [user_id, email, display_name].all?(&:present?)
      
      # This is the data sent to UserVoice encrypted inside the token.
      options = { :guid => "#{ENV['RAILS_ENV'] || ENV['RACK_ENV']}-#{user_id}", :email => email, :display_name => display_name }
      # TODO: Do we want auth tokens to expire?
      # options.merge!({ :expires => (Time.zone.now.utc + 5 * 60).to_s })

      key = ::EzCrypto::Key.with_password(LeapauthHelper.config.uservoice_subdomain, LeapauthHelper.config.uservoice_sso_key)
      encrypted = key.encrypt(options.to_json)
      uservoice_token = Base64.encode64(encrypted).gsub(/\n/,'') # Remove line returns which are otherwise annoyingly placed every 60 characters.

      return CGI.escape(uservoice_token)
    end
  end
end
