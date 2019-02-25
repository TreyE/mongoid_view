require "mongoid_view/version"
require "active_support/dependencies/autoload"
require "mongoid"

module MongoidView
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Expressions
    autoload :Pipeline
    autoload :ExpressionHelpers
    autoload :ViewDocument
  end
end
