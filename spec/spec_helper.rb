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

def slack_url_with_params(path, params=nil)
  "https://slack.com/api#{path}?#{parameterize(params)}"
end

def auth_slack_url(path)
  "https://slack.com/api#{path}?token=#{test_slack_token}"
end

def auth_client
  Slack::Client.new(ENV.fetch('SLACK_TEST_TEAM'), ENV.fetch('SLACK_TEST_TOKEN'))
end

def parameterize(params)
  URI.escape(params.collect{|k,v| "#{k}=#{v}"}.join('&'))
end
