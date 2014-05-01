require 'faraday'
require 'slack/error'

module Slack
  # Faraday response middleware
  module Response

    class RaiseError < Faraday::Response::Middleware

      private

      def on_complete(response)
        if error = Slack::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
