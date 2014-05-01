require "spec_helper"

describe Slack::Client do

  before do
    @client = auth_client
  end

  describe "#initialize" do
    it "requires team name" do
      expect { described_class.new(nil, nil) }.
        to raise_error ArgumentError, "Team name required"
    end

    it "requires token" do
      expect { described_class.new("foobar", nil) }.
        to raise_error ArgumentError, "Token required"
    end

    it "raises error on invalid team name" do
      names = ["foo bar", "foo $bar", "foo.bar"]

      names.each do |name|
        expect { described_class.new(name, "token") }.
          to raise_error "Invalid team name"
      end
    end
  end

  describe "#post_message", :vcr do
    it "posts a message to one channel" do
      result = @client.post_message("May the force be with you", "yoda-quotes")
      expect(result).to be true
      params = {text: "May the force be with you", channel: "#yoda-quotes", token: test_slack_token}
      assert_requested :post, slack_url_with_params("/chat.postMessage", params)
    end

    it "returns channel not found error" do
      expect{
        @client.post_message("May the force be with you", "channel-name")
      }.to raise_error(Slack::ChannelNotFound)

      params = {text: "May the force be with you", channel: "#channel-name", token: test_slack_token}
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
