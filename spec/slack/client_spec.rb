require "spec_helper"

describe Slack::Client do

  before do
    Slack.reset!
    @client = auth_client
  end

  after do
    Slack.reset!
  end

  describe "module configuration" do

    before do
      Slack.reset!
      Slack.configure do |config|
        Slack::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      Slack.reset!
    end

    it "inherits the module configuration" do
      client = Slack::Client.new
      Slack::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq("Some #{key}")
      end
    end

    describe "with class level configuration" do

      before do
        @opts = {
          :connection_options => {:ssl => {:verify => false}},
          :api_endpoint => "https://slack.dev/api",
          :token        => "abcdef",
          :team         => "netflower"
        }
      end

      it "overrides module configuration" do
        client = Slack::Client.new(@opts)
        expect(client.api_endpoint).to eq("https://slack.dev/api")
        expect(client.token).to eq("abcdef")
        expect(client.instance_variable_get(:"@team")).to eq("netflower")
        expect(client.default_media_type).to eq(Slack.default_media_type)
        expect(client.user_agent).to eq(Slack.user_agent)
      end

      it "can set configuration after initialization" do
        client = Slack::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        expect(client.api_endpoint).to eq("https://slack.dev/api")
        expect(client.token).to eq("abcdef")
        expect(client.instance_variable_get(:"@team")).to eq("netflower")
        expect(client.default_media_type).to eq(Slack.default_media_type)
        expect(client.user_agent).to eq(Slack.user_agent)
      end
    end
  end

  describe ".client" do
    it "creates an Slack::Client" do
      expect(Slack.client).to be_kind_of Slack::Client
    end
    it "caches the client when the same options are passed" do
      expect(Slack.client).to eq(Slack.client)
    end
    it "returns a fresh client when options are not the same" do
      client = Slack.client
      Slack.token = "abcdefabcdefabcdefabcdef"
      client_two = Slack.client
      client_three = Slack.client
      expect(client).not_to eq(client_two)
      expect(client_three).to eq(client_two)
    end
  end

  describe ".configure" do
    Slack::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Slack.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Slack.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end
  end

  describe "when making requests", :vcr do
    it "sets a default user agent" do
      @client.channels

      assert_requested :get, auth_slack_url("/channels.list"), :headers => {:user_agent => Slack::Default.user_agent}

    end
    it "sets a custom user agent for GET request" do
      user_agent = "Mozilla/5.0 I am Spartacus!"
      client = auth_client({:user_agent => user_agent})
      client.channels

      assert_requested :get, auth_slack_url("/channels.list"), :headers => {:user_agent => user_agent}
    end

    it "sets a custom user agent for POST request" do
       user_agent = "Mozilla/5.0 I am Spartacus!"
       client = auth_client({:user_agent => user_agent})
       client.post_message("May the force be with you", "yoda-quotes")

       params = {text: "May the force be with you", channel: "#yoda-quotes", token: test_slack_token, username: Slack.default_username}
       assert_requested :post, slack_url_with_params("/chat.postMessage", params), :headers => {:user_agent => user_agent}
    end
  end

  describe "#post_message", :vcr do
    it "posts a message to one channel" do
      result = @client.post_message("May the force be with you", "yoda-quotes")
      expect(result).to be true
      params = {text: "May the force be with you", channel: "#yoda-quotes", token: test_slack_token, username: Slack.default_username}
      assert_requested :post, slack_url_with_params("/chat.postMessage", params)
    end

    it "returns channel not found error" do
      expect{
        @client.post_message("May the force be with you", "channel-name")
      }.to raise_error(Slack::ChannelNotFound)

      params = {text: "May the force be with you", channel: "#channel-name", token: test_slack_token, username: Slack.default_username}
      assert_requested :post, slack_url_with_params("/chat.postMessage", params)
    end
  end

  describe "#channels", :vcr do
    it "returns all channels" do
      channels = @client.channels
      expect(channels).to be_kind_of Array
      assert_requested :get, auth_slack_url("/channels.list")
    end
  end
end
