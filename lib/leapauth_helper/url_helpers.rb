require 'rack'
module LeapauthHelper
  class UrlHelpers
    class << self
      # make these kinda private
      def use_secure_transactions?
        %(production staging).include?(Rails.env)
      end
      
      def use_secure?
        %(production).include?(Rails.env)
      end
      
      def secure_url(path, opts = {})
        scheme = use_secure? ? "https" : "http"
        url = "#{scheme}://#{LeapauthHelper.config.auth_host}#{path}"
        opts.empty? ? url : "#{url}?#{Rack::Utils.build_query(opts)}"
      end

      def home_url(path, opts = {})
        # For some reason, config.home has the scheme baked in, but the others don't.
        # Just in case changing it would be a breaking change, I won't change it. But... WTF.
        url = "#{LeapauthHelper.config.home}#{path}"
        opts.empty? ? url : "#{url}?#{Rack::Utils.build_query(opts)}"
      end
    end
  end
end
