module MongoidView
  module Expressions
  class Sort < Raw
    def expression_step
      :sort
    end

    def to_hash
      {
        "$sort" => @expression
      }
    end
  end
  end
end
