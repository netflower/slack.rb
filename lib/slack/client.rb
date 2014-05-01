require "json"
require "faraday"

module Slack
  class Client
    include Slack::Connection

    def initialize(team, token, options = {})
      @team       = team
      @token      = token
      @username   = options[:username]
      @channel    = options[:channel]

      validate_arguments
    end

    def post_message(text, channel)
      payload = Slack::Payload.new(
        text:       text,
        channel:    channel,
        username:   @username,
        token:      @token
      )

      post('chat.postMessage', payload)
    end

    def channels
      @channels ||= _channels
    end

    private

    def validate_arguments
      raise ArgumentError, "Team name required" if @team.nil?
      raise ArgumentError, "Token required"     if @token.nil?
      raise ArgumentError, "Invalid team name"  unless valid_team_name?
    end

    def valid_team_name?
      @team =~ /^[a-z\d\-]+$/ ? true : false
    end

    def _channels
      response = get('channels.list')
      response['channels']
    end
  end
end
