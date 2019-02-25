module MongoidView
  module ViewDocument
    def self.included(base)
      base.class_exec do
        def self.source_model(s_model)
          s_model_constant = s_model.kind_of?(String) ? s_model.constantize : s_model
          @source_collection = s_model_constant.collection
          self.class_exec do
            include Mongoid::Document
            extend ::MongoidView::ExpressionHelpers
            store_in(collection: ("mongoid_views." + self.name.collectionize))
          end
        end

        def self.source_collection
          @source_collection
        end

        def self.wrap_query(q, opts = {})
          ::MongoidView::ResultWrapper.new(self, self.source_collection, q.to_pipeline, opts)
        end
      end
    end
  end
end
