require 'slack/client'
require 'slack/default'

module Slack

  class << self
    include Slack::Configurable

    # API client based on configured options {Configurable}
    #
    # @return [Slack::Client] API wrapper
    def client
      @client = Slack::Client.new(options) unless defined?(@client) && @client.same_options?(options)
      @client
    end

    # see: http://robots.thoughtbot.com/always-define-respond-to-missing-when-overriding
    # @private
    def respond_to_missing?(method_name, include_private=false)
      client.respond_to?(method_name, include_private)
    end

  private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end
  end
end

Slack.setup
