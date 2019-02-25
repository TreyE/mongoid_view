module MongoidView
  module Expressions
  class Project < Raw
    def expression_step
      :project
    end

    def to_hash
      {
        "$project" => @expression
      }
    end
  end
  end
end
