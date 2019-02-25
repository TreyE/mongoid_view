require "spec_helper"

module MongoidView
  module TestClasses
    class SourceViewDoc
      include Mongoid::Document

      field :name, type: String
    end

    class ExampleDocWrapper
      include MongoidView::ViewDocument

      source_model(::MongoidView::TestClasses::SourceViewDoc)

      field :name_count, type: Integer

      def self.count_all_names_query
        group_by(
          "$name",
          {"name_count" => {"$sum" => 1}}
        )
      end

      def self.count_all_names
        wrap_query(count_all_names_query)
      end
    end
  end
end

describe MongoidView::ViewDocument do

  describe "being used to build a an aggregate result" do
    let(:source_records) { [MongoidView::TestClasses::SourceViewDoc.create!(:name => "a name"), MongoidView::TestClasses::SourceViewDoc.create!(:name => "a name")] }

    after :each do
      MongoidView::TestClasses::SourceViewDoc.where({}).delete
    end

    it "correctly counts the records with the same name" do
      name = source_records.first.name
      expected_count = source_records.group_by { |sr| sr.name }.values.first.length
      results = MongoidView::TestClasses::ExampleDocWrapper.count_all_names
      expect(results.first.id).to eq(name)
      expect(results.first.name_count).to eq(expected_count)
    end
  end

end