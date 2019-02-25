module MongoidView
  module Expressions
  class Unwind < Raw
    def expression_step
      :unwind
    end

    def to_hash
      {
        "$unwind" => @expression
      }
    end
  end
  end
end
