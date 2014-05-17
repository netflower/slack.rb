module Slack
  class Payload
    attr_accessor :username, :channel, :text, :token

    def initialize(options = {})
      @username   = options[:username] || Slack.username
      @channel    = options[:channel] || Slack.default_channel
      @text       = options[:text]
      @token      = options[:token]

      unless channel[0] =~ /^(#|@)/
        @channel = "##{@channel}"
      end
    end

    def to_hash
     hash = {
        text:       text,
        username:   username,
        channel:    channel,
        token:      token
      }

      hash.delete_if { |_,v| v.nil? }
    end
  end
end
