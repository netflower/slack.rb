require "spec_helper"

describe Slack::Payload do
  let(:options) do
    {
      username: "foo",
      channel: "#bar",
      text: "hola"
    }
  end

  describe "#initialize" do
    let(:payload) { described_class.new(options) }

    context "with options" do
      it "sets username" do
        expect(payload.username).to eq "foo"
      end

      it "sets channel" do
        expect(payload.channel).to eq "#bar"
      end

      it "sets text" do
        expect(payload.text).to eq "hola"
      end

      context "on missing pound in channel" do
        let(:options) do
          { channel: "foo" }
        end

        it "adds pound symbol" do
          expect(payload.channel).to eq "#foo"
        end
      end

      context "on direct message" do
        let(:options) do
          { channel: "@dan" }
        end

        it "keeps the symbol" do
          expect(payload.channel).to eq "@dan"
        end
      end
    end

    context "without options" do
      let(:options) { Hash.new }

      it "sets username" do
        expect(payload.username).to eq "My Bot"
      end

      it "sets channel" do
        expect(payload.channel).to eq "#general"
      end
    end
  end

  describe "#to_hash" do
    let(:hash) { described_class.new(options).to_hash }

    it "includes basic attributes" do
      expect(hash).to eq({
        channel: "#bar",
        text: "hola",
        username: "foo"
      })
    end

    context "when channel is not set" do
      before do
        options[:channel] = nil
      end

      it "excludes channel" do
        expect(hash.keys).not_to include "channel"
      end
    end

    context "when attachment is not set" do
      before do
        options[:attachments] = nil
      end

      it "excludes attachments" do
        expect(hash.keys).not_to include "attachments"
      end
    end
  end
end
