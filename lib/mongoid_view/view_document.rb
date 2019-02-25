module MongoidView
  module ViewDocument
    def self.included(base)
      base.class_exec do
        include Mongoid::Document
        extend ::MongoidView::ExpressionHelpers

        store_in(collection: ("mongoid_views." + self.name.collectionize))
      end
    end
  end
end
