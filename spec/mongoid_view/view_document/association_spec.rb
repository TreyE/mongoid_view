require "spec_helper"

module MongoidView
  module TestClasses
    class SourceViewDocParent
      include Mongoid::Document

      field :name, type: String
      has_many :source_view_doc_children
    end

    class SourceViewDocChild
      include Mongoid::Document

      belongs_to :source_view_doc_parent, inverse_of: :source_view_doc_children
    end

    class ExampleAssociationDocWrapper
      include Mongoid::Document

      include MongoidView::ViewDocument

      field :name, type: String

      embeds_many :source_view_doc_children, :inverse_of => nil

      source_model("::MongoidView::TestClasses::SourceViewDocParent")

      def self.parents_with_children_query
        expr(
          {"$lookup" => {
            "from" => ::MongoidView::TestClasses::SourceViewDocChild.collection_name.to_s,
            "localField" => "_id",
            "foreignField" => "source_view_doc_parent_id",
            "as" => "source_view_doc_children"
          }}
        )
      end

      def self.all_parents_with_children
        wrap_query(parents_with_children_query)
      end
    end
  end
end

describe MongoidView::ViewDocument do
  describe "being used to build an aggregate with an associated document" do
    let(:source_record) { MongoidView::TestClasses::SourceViewDocParent.create!(:name => "a name") }
    let(:source_child) { MongoidView::TestClasses::SourceViewDocChild.create!(:source_view_doc_parent_id => source_record.id) }

    after :each do
      MongoidView::TestClasses::SourceViewDocParent.where({}).delete
      MongoidView::TestClasses::SourceViewDocChild.where({}).delete
    end

    it "correctly loads the child as an embedded document" do
      parent = source_record
      child = source_child
      results = MongoidView::TestClasses::ExampleAssociationDocWrapper.all_parents_with_children
      expect(results.first.source_view_doc_children.first.id).to eq(child.id)
    end
  end
end