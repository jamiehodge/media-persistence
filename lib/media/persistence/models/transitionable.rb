module Media
  module Persistence
    module Models
      module Transitionable

        def transitionable
          plugin :dirty
          include InstanceMethods
        end

        module InstanceMethods

          def validates_transition(cols)
            Array(cols).each do |column|
              next unless column_changed?(column)
              errors.add(column, "is invalid") unless valid_transition?(column)
            end
          end

          def valid_transition?(column)
            transitions = send("#{column}_transitions")
            transitions[initial_value(column)].include?(send(column))
          end
        end
      end
    end
  end
end
