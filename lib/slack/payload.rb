module Slack
  class Payload
    attr_accessor :username, :channel, :text, :token, :icon_url, :attachments

    def initialize(options = {})
      @username    = options[:username] || Slack.username
      @channel     = options[:channel]  || Slack.default_channel
      @text        = options[:text]
      @token       = options[:token]
      @icon_url    = options[:icon_url]
      @attachments = options[:attachments]

      unless channel[0] =~ /^(#|@)/
        @channel = "##{@channel}"
      end
    end

    def to_hash
     hash = {
        text:        text,
        username:    username,
        channel:     channel,
        token:       token,
        icon_url:    icon_url,
        attachments: attachments.to_json
      }

      hash.delete_if { |_,v| v.nil? || v == "null"}
    end
  end
end
