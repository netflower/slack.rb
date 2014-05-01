require "slack/version"

module Slack
  require 'slack/response/raise_error'
  require "slack/error"
  require "slack/connection"
  require "slack/payload"
  require "slack/client"

  # Default API endpoint
  API_ENDPOINT = "https://slack.com/api/".freeze

  # Default User Agent header string
  USER_AGENT   = "Slack Ruby Gem #{Slack::VERSION}".freeze

  # Default media type
  MEDIA_TYPE   = "application/json"

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

  # Default options for Faraday::Connection
  # @return [Hash]
  def connection_options
    {
      :headers => {
        :accept => default_media_type,
        :user_agent => user_agent
      }
    }
  end
end
