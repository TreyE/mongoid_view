module MongoidView
  class ResultWrapper
    include Enumerable

    def initialize(r_klass, source_collection, query, opts)
      @result_klass = r_klass
      @source_collection = source_collection
      @query = query
      @options = opts
    end

    def each
      @source_collection.aggregate(@query, @options).each do |rec|
        yield ::Mongoid::Factory.from_db(@result_klass,rec)
      end
    end
  end
end
