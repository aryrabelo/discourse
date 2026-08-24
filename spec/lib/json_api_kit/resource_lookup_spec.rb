# frozen_string_literal: true

class SpecOrphanResource < JsonApiKit::Resource
end

class SpecImpostorResource
end

class SpecTwinResource < JsonApiKit::Resource
end

module SpecLookup
  class UserResource < JsonApiKit::Resource
  end

  class SpecTwinResource < JsonApiKit::Resource
  end

  class QueryResource < JsonApiKit::Resource
  end
end

RSpec.describe JsonApiKit::ResourceLookup do
  subject(:found) { described_class.resource(declaration, within: SpecLookup::QueryResource) }

  let(:declaration) { :user }

  it "returns the resource of that name in its own namespace" do
    expect(found).to eq(SpecLookup::UserResource)
  end

  context "when the name is plural" do
    let(:declaration) { :users }

    it "returns the resource of the singular name" do
      expect(found).to eq(SpecLookup::UserResource)
    end
  end

  context "when its own namespace holds no such resource" do
    let(:declaration) { :spec_orphan }

    it "returns the resource of that name at the root" do
      expect(found).to eq(SpecOrphanResource)
    end
  end

  context "when both its own namespace and the root hold one" do
    let(:declaration) { :spec_twin }

    it "returns the one in its own namespace" do
      expect(found).to eq(SpecLookup::SpecTwinResource)
    end
  end

  context "when no namespace holds one" do
    let(:declaration) { :author }

    it "names what it looked for" do
      expect { found }.to raise_error(
        described_class::MissingResource,
        "SpecLookup::QueryResource: no resource is named author, " \
          "tried SpecLookup::AuthorResource, AuthorResource",
      )
    end
  end

  context "when the declaration is a resource class" do
    let(:declaration) { SpecOrphanResource }

    it "returns that class" do
      expect(found).to eq(SpecOrphanResource)
    end
  end

  context "when the declaration is a class of another kind" do
    let(:declaration) { Topic }

    it "refuses it" do
      expect { found }.to raise_error(
        described_class::UnsupportedResource,
        "SpecLookup::QueryResource: Topic is not a JSON:API resource",
      )
    end
  end

  context "when the name matches a class of another kind" do
    let(:declaration) { :spec_impostor }

    it "refuses it" do
      expect { found }.to raise_error(
        described_class::UnsupportedResource,
        "SpecLookup::QueryResource: SpecImpostorResource is not a JSON:API resource",
      )
    end
  end
end
