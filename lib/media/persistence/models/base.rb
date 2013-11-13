require "sequel"

module Media
  module Persistence
    module Models
      Base = Class.new(Sequel::Model) do
        plugin :auto_validations, not_null: :presence
        plugin :optimistic_locking
        plugin :prepared_statements
        plugin :prepared_statements_associations
        plugin :string_stripper
      end
    end
  end
end
