require "spec_helper"

module MongoidView
  module TestClasses
    class SourceDoc
      include Mongoid::Document
    end

    class ExampleDoc
      include MongoidView::ViewDocument

      source_model("::MongoidView::TestClasses::SourceDoc")
    end
  end
end

describe MongoidView::ViewDocument do

  describe "included in a class" do

    it "has the correct collection name" do
      expect(MongoidView::TestClasses::ExampleDoc.collection_name.to_s).to eq("mongoid_views.mongoid_view_test_classes_example_docs")
    end

  end

end