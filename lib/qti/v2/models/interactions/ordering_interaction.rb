require 'qti/v2/models/interactions/choice_interaction'

module Qti
  module V2
    module Models
      module Interactions
        class OrderingInteraction < ChoiceInteraction
          def self.matches(node, parent)
            match = node.at_xpath('.//xmlns:orderInteraction')
            return false unless match.present?
            new(node, parent)
          end

          def shuffled?
            node.at_xpath('.//xmlns:orderInteraction').attributes['shuffle']&.value&.downcase == 'true'
          end
        end
      end
    end
  end
end
