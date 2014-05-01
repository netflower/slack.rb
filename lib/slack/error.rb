module Slack
  class Error < StandardError

    # Returns the appropriate Slack::Error sublcass based
    # on error message
    #
    # @param [Hash] response HTTP response
    # @return [Slack::Error]
    def self.from_response(response)
      status  = response[:status].to_i
      headers = response[:response_headers]
      body = JSON.parse(response.body)
      ok = ["true", 1].include? body['ok']
      error = body['error']

      unless ok
        if klass = case error
                     when "invalid_auth"      then Slack::InvalidAuth
                     when "account_inactive"  then Slack::AccountInactive
                     when "channel_not_found" then Slack::ChannelNotFound
                     when "is_archived"       then Slack::IsArchived
                   end
          klass.new(response)
        end
      end
    end

    def initialize(response=nil)
      @response = response
      super(build_error_message)
    end

    def build_error_message
      return nil if @response.nil?

      message =  "#{@response['method'].to_s.upcase} "
      message << "#{@response['url'].to_s}: "
      message << "#{@response['status']} - "
      message
    end
  end

  # Raised when a invalid authentication token was given
  class InvalidAuth < Error; end

  # Raised when authentication token is for a deleted user or team
  class AccountInactive < Error; end

  # Raised when value passed for channel was invalid
  class ChannelNotFound < Error; end

  # Raised when Channel has been archived
  class IsArchived < Error; end
end
