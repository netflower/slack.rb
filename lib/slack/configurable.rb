module Slack

  module Configurable

    attr_accessor :token, :team, :username, :icon_url, :api_endpoint, :default_media_type,
                  :user_agent, :default_channel, :connection_options, :middleware
    attr_writer :api_endpoint

    class << self

      # List of configurable keys for {Octokit::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :token,
          :team,
          :username,
          :icon_url,
          :api_endpoint,
          :user_agent,
          :connection_options,
          :default_media_type,
          :default_channel,
          :middleware
        ]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      Slack::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Slack::Default.options[key])
      end
      self
    end
    alias setup reset!

    private

    def options
      Hash[Slack::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end
  end
end
