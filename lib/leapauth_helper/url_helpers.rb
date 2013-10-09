require 'rack'

module LeapauthHelper
  class UrlHelpers
    class << self
      # TODO: make these kinda private. Do we need both of the following?
      def use_secure_transactions?
        %(production staging).include?(Rails.env)
      end
      
      def use_secure?
        %(production staging).include?(Rails.env)
      end
      
      def secure_url(path, opts = {})
        scheme = use_secure? ? "https" : "http"
        url = "#{scheme}://#{LeapauthHelper.config.auth_host}#{path}"
        opts.empty? ? url : "#{url}?#{Rack::Utils.build_query(opts)}"
      end

      def home_url(path, opts = {})
        scheme = use_secure? ? "https" : "http"
        url = "#{scheme}://#{LeapauthHelper.config.home}#{path}"
        opts.empty? ? url : "#{url}?#{Rack::Utils.build_query(opts)}"
      end

      def warehouse_url(path, opts = {})
        scheme = use_secure_transactions? ? "https" : "http"
        url = "#{scheme}://#{LeapauthHelper.config.transactions_host}#{path}"
        opts.empty? ? url : "#{url}?#{Rack::Utils.build_query(opts)}"
      end
    end
  end
end
