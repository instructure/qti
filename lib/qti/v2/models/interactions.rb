require 'qti/v2/models/interactions/base_interaction'
Dir["#{__dir__}/interactions/*.rb"].each { |f| load f }

module Qti
  module V2
    module Models
      module Interactions
        # This one finds the correct parsing model based on the provided xml node
        def self.interaction_model(node)
          # Check for matches
          matches = subclasses.each_with_object([]) do |interaction_class, result|
            match = interaction_class.matches(node)
            result << match if match
          end

          raise V2::UnsupportedSchema if matches.size > 1

          matches.first
        end

        def self.subclasses
          constants.map { |c| const_get(c) }
                   .reject { |c| c.name =~ /Implementations|Base/ }
                   .select { |c| c.name =~ /^Qti::V2.*Interaction$/ }
        end
      end
    end
  end
end
