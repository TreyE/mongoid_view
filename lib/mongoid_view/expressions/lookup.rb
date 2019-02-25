module MongoidView
  module Expressions
    class Lookup < Raw
      def initialize(f_collection_name, foreign_field, local_field, as_name)
        @from_collection_name = f_collection_name
        @foreign_field_name = foreign_field
        @local_field_name = local_field
        @as_property_name = as_name
      end

      def expression_step
        :sort
      end

      def to_hash
        {
          "$lookup" => {
            "from" => @from_collection_name,
            "localField" => @local_field_name,
            "foreignField" => @foreign_field_name,
            "as" => @as_property_name
          }
        }
      end
    end
  end
end