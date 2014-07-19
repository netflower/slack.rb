require "json"
require "faraday"
require 'slack/configurable'
require "slack/error"
require "slack/connection"
require "slack/payload"
require "slack/structs"

module Slack
  class Client
    include Slack::Configurable
    include Slack::Connection

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      Slack::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Slack.instance_variable_get(:"@#{key}"))
      end
    end

    def same_options?(opts)
      opts.hash == options.hash
    end

    def post_message(text, channel, options = {})
      payload = Slack::Payload.new(
        text:        text,
        channel:     channel,
        username:    @username,
        token:       @token,
        icon_url:    @icon_url,
        attachments: options[:attachments]
      )

      response = post('chat.postMessage', payload)
      valid_response?(response)
    end

    def channels
      @channels ||= _channels
    end

    private

    def _channels
      response = get('channels.list')
      JSON.parse(response.body)['channels']
    end

    def valid_response?(response)
      body = JSON.parse(response.body)
      [true, 1].include? body['ok']
    end
  end
end
