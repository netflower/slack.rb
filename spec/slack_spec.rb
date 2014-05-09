require 'spec_helper'

describe Slack do
  before do
    Slack.reset!
  end

  after do
    Slack.reset!
  end

  it "sets defaults" do
    Slack::Configurable.keys.each do |key|
      expect(Slack.instance_variable_get(:"@#{key}")).to eq(Slack::Default.send(key))
    end
  end
end
