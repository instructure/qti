# Populate the subclasses
Dir["#{__dir__}/interactions/*.rb"].each { |f| load f }

module Qti
  module V1
    module Models
      module Interactions
        # This one finds the correct parsing model based on the provided xml node
        def self.interaction_model(node, parent)
          subclasses = constants.map { |c| const_get(c) }
          # Check for matches
          matches = subclasses.each_with_object([]) do |interaction_class, result|
            match = interaction_class.matches(node, parent)
            result << match if match
          end
          raise UnsupportedSchema if matches.size != 1
          matches.first
        end
      end
    end
  end
end
