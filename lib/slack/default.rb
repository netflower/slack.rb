require 'slack/response/raise_error'
require 'slack/version'

module Slack

  module Default

    # Default API entpoint
    API_ENDPOINT    = "https://slack.com/api/".freeze

    # Default User Agent header string
    USER_AGENT      = "Slack Ruby Gem #{Slack::VERSION}".freeze

    # Default media type
    MEDIA_TYPE      = "application/json"

    # Default channel type
    DEFAULT_CHANNEL = "#general"

    # Default username
    DEFAULT_USERNAME = "My Bot"

    # Default Faraday middleware stack
    MIDDLEWARE = Faraday::RackBuilder.new do |builder|
      builder.use(Faraday::Request::UrlEncoded)
      builder.use Slack::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end

    class << self

      # Configuration options
      # @return [Hash]
      def options
        Hash[Slack::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # Default token from ENV
      # @return [String]
      def token
        ENV['SLACK_TOKEN']
      end

      # Default team from ENV
      # @return [String]
      def team
        ENV['SLACK_TEAM']
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        ENV['SLACK_API_ENDPOINT'] || API_ENDPOINT
      end

      # Default media type from ENV or {MEDIA_TYPE}
      # @return [String]
      def default_media_type
        ENV['SLACK_DEFAULT_MEDIA_TYPE'] || MEDIA_TYPE
      end

      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['SLACK_USER_AGENT'] || USER_AGENT
      end

      # Default Channel from ENV or {DEFAULT_CHANNEL}
      # @return [String]
      def default_channel
        ENV['SLACK_DEFAULT_CHANNEL'] || DEFAULT_CHANNEL
      end

      # Default Username from ENV or {DEFAULT_USERNAME}
      # @return [String]
      def default_username
        ENV['SLACK_DEFAULT_USERNAME'] || DEFAULT_USERNAME
      end

      # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          :headers => {
            :accept => default_media_type,
            :user_agent => user_agent
          },
          :builder => middleware
        }
      end

      # Default middleware stack for Faraday::Connection
      # from {MIDDLEWARE}
      # @return [String]
      def middleware
        MIDDLEWARE
      end
    end
  end
end
