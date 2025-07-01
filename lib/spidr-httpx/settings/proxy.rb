# frozen_string_literal: true

require_relative '../proxy'

require 'uri/http'

module SpidrHttpx
  module Settings
    #
    # Methods for configuring a proxy.
    #
    # @since 0.6.0
    #
    module Proxy
      #
      # Proxy information used by all newly created Agent objects by default.
      #
      # @return [SpidrHttpx::Proxy]
      #   The SpidrHttpx proxy information.
      #
      def proxy
        @proxy ||= SpidrHttpx::Proxy.new
      end

      #
      # Sets the proxy information used by Agent objects.
      #
      # @param [SpidrHttpx::Proxy, Hash, URI::HTTP, String, nil] new_proxy
      #   The new proxy information.
      #
      # @option new_proxy [String] :host
      #   The host-name of the proxy.
      #
      # @option new_proxy [Integer] :port (COMMON_PROXY_PORT)
      #   The port of the proxy.
      #
      # @option new_proxy [String] :user
      #   The user to authenticate with the proxy as.
      #
      # @option new_proxy [String] :password
      #   The password to authenticate with the proxy.
      #
      # @return [SpidrHttpx::Proxy]
      #   The new proxy information.
      #
      def proxy=(new_proxy)
        @proxy = case new_proxy
                 when SpidrHttpx::Proxy
                   new_proxy
                 when Hash
                   SpidrHttpx::Proxy.new(**new_proxy)
                 when String, URI::HTTP
                   proxy_uri = URI(new_proxy)

                   SpidrHttpx::Proxy.new(
                     host: proxy_uri.host,
                     port: proxy_uri.port,
                     user: proxy_uri.user,
                     password: proxy_uri.password
                   )
                 when nil
                   SpidrHttpx::Proxy.new
                 else
                   raise(TypeError,
                         "#{self.class}#{__method__} only accepts SpidrHttpx::Proxy, URI::HTTP, Hash, or nil")
                 end
      end

      #
      # Disables the proxy settings used by all newly created Agent objects.
      #
      def disable_proxy!
        @proxy = SpidrHttpx::Proxy.new
        true
      end
    end
  end
end
