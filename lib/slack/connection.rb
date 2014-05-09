module Slack
  module Connection
    def get(method)
      response = connection.get method, { token: @token }

      if response.success?
        response
      else
        raise UnknownResponseCode, "Unexpected #{response.code}"
      end
    end

    def post(method, payload)
      response = connection.post do |req|
        req.url method, payload.to_hash
      end
    end

    def connection
      _connection = Faraday.new(@api_endpoint, @connection_options)
      _connection.headers = {'Accept' => @default_media_type, 'User-Agent' => @user_agent}
      _connection
    end
  end
end
