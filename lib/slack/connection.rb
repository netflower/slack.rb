module Slack
  module Connection
    def get(method)
      response = connection.get method, { token: @token }

      if response.success?
        JSON.parse(response.body)
      else
        raise UnknownResponseCode, "Unexpected #{response.code}"
      end
    end

    def post(method, payload)
      response = connection.post do |req|
        req.url method, payload.to_hash
        req.headers['Content-Type'] = 'application/json'
        #req.body = JSON.dump(payload.to_hash)
      end

      handle_response(response)
    end

    def base_url
      #"https://#{@team}.slack.com/api/"
      "https://slack.com/api/"
    end

    def connection
      Faraday.new(base_url) do |c|
        c.use(Faraday::Request::UrlEncoded)
        c.use(Slack::Response::RaiseError)
        c.adapter(Faraday.default_adapter)
      end
    end

    def handle_response(response)
      body = JSON.parse(response.body)
      true if ["true", 1].include? body['ok']
    end
  end
end
