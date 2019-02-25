module MongoidView
  module Expressions
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Raw
      autoload :Group
      autoload :Lookup
      autoload :Project
      autoload :Sort
      autoload :Unwind
    end

    def self.eager_load!
      super
      autoloads.keys.each do |al|
        self.const_get(al).eager_load!
      end
    end
  end
end
