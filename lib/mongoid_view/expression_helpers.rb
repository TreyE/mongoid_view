module MongoidView
  module ExpressionHelpers
    def last(value, from_expression=nil)
      lookup_expression = from_expression.nil? ? "$#{value}" : from_expression
      ::MongoidView::Expressions::Raw.new({value => {"$last" => lookup_expression}})
    end

    def group_by(id_stuff, other_props = {})
      ::MongoidView::Expressions::Group.new(
        id_stuff,
        other_props
      )
    end

    def project(exps ={})
      ::MongoidView::Expressions::Project.new(exps)
    end

    def project_property(name, exp)
      ::MongoidView::Expressions::Project.new({
        name => exp
      })
    end

    def sort_on(expr)
      ::MongoidView::Expressions::Sort.new(expr)
    end

    def expr(expr)
      ::MongoidView::Expressions::Raw.new(expr)
    end

    def unwind(expr)
      ::MongoidView::Expressions::Unwind.new(expr)
    end

    def lookup(from_collection_name, foreign_field:, local_field: "_id", as: from_collection_name)
      ::MongoidView::Expressions::Lookup.new(from_collection_name, foreign_field, local_field, as)
    end
  end
end
