# frozen_string_literal: true

RSpec.describe JsonApiKit::RecordUrl do
  subject(:url) { described_class.new(base, record) }

  let(:base) { "https://example.com/api" }
  let(:namespace) { nil }
  let(:record) { instance_double(JsonApiKit::Record, namespace:, type: "topics", id: "5") }

  describe "#to_s" do
    it "returns the URL of the record" do
      expect(url.to_s).to eq("https://example.com/api/topics/5")
    end

    context "when the resource declares a namespace" do
      let(:namespace) { "data-explorer" }

      it "puts the namespace before the type" do
        expect(url.to_s).to eq("https://example.com/api/data-explorer/topics/5")
      end
    end
  end

  describe "#relationship" do
    it "returns the URL of the relationship itself" do
      expect(url.relationship("posts").to_s).to eq(
        "https://example.com/api/topics/5/relationships/posts",
      )
    end
  end

  describe "#related" do
    it "returns the URL of the records a relationship points at" do
      expect(url.related("posts").to_s).to eq("https://example.com/api/topics/5/posts")
    end
  end
end
