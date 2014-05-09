require 'slack'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
end

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<SLACK_TEAM>") do
      ENV['SLACK_TEST_TEAM']
  end
  c.filter_sensitive_data("<SLACK_TOKEN>") do
    ENV['SLACK_TEST_TOKEN']
  end
  c.default_cassette_options = {
    :serialize_with             => :json,
    :preserve_exact_body_bytes  => false,
    :decode_compressed_response => true,
    :record                     => ENV['TRAVIS'] ? :none : :once
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def test_slack_team
  ENV.fetch 'SLACK_TEST_TEAM', 'x' * 12
end

def test_slack_token
  ENV.fetch 'SLACK_TEST_TOKEN', 'x' * 45
end

def slack_url(path)
  "https://slack.com/api#{path}"
end

def slack_url_with_params(path, params={})
  "https://slack.com/api#{path}?#{parameterize(params)}"
end

def auth_slack_url(path, params={})
  slack_url_with_params(path, {token: test_slack_token}.merge(params))
end

def stub_delete(url)
  stub_request(:delete, auth_slack_url(url))
end

def stub_get(url)
  stub_request(:get, auth_slack_url(url))
end

def stub_head(url)
  stub_request(:head, auth_slack_url(url))
end

def stub_patch(url)
  stub_request(:patch, auth_slack_url(url))
end

def stub_post(url, params)
  stub_request(:post, auth_slack_url(url, params))
end

def stub_put(url)
  stub_request(:put, auth_slack_url(url))
end

def auth_client(options={})
  Slack::Client.new({team: ENV.fetch('SLACK_TEST_TEAM'), token: ENV.fetch('SLACK_TEST_TOKEN')}.merge(options))
end

def parameterize(params)
  URI.escape(params.collect{|k,v| "#{k}=#{v}"}.join('&'))
end
