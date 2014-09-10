require 'rack'

module LeapauthHelper
  class UrlHelpers
    class << self

      def secure_url(path, opts = {})
        build_url LeapauthHelper.config.auth_host, path, opts
      end

      def home_url(path, opts = {})
        build_url LeapauthHelper.config.home, path, opts
      end

      def warehouse_url(path, opts = {})
        build_url LeapauthHelper.config.transactions_host, path, opts
      end

      def airspace_url(path, opts = {})
        build_url LeapauthHelper.config.airspace_host, path, opts
      end

      def app_store_url(path, opts = {})
        build_url LeapauthHelper.config.app_store_host, path, opts
      end

      def developer_url(path, opts = {})
        build_url LeapauthHelper.config.developer_host, path, opts
      end

      def use_secure?
        %(production staging).include?(Rails.env)
      end

      def build_url(domain, path, opts = {})
        scheme = use_secure? ? "https" : "http"
        url = "#{scheme}://#{domain}#{path}"
        opts = opts.delete_if { |key, value| value.nil? }
        opts.empty? ? url : "#{url}?#{Rack::Utils.build_query(opts)}"
      end

    end
  end
end
