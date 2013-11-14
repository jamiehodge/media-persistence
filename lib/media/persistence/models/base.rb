require "sequel"
require_relative "storable"

module Media
  module Persistence
    module Models

      UUID = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/

      Base = Class.new(Sequel::Model) do
        extend Storable

        self.raise_on_save_failure     = false
        self.raise_on_typecast_failure = false
        self.strict_param_setting      = false

        plugin :auto_validations, not_null: :presence
        plugin :optimistic_locking
        plugin :prepared_statements
        plugin :prepared_statements_associations
        plugin :string_stripper

        def validates_uuid(columns)
          validates_format UUID, columns
        end
      end
    end
  end
end
