module Qti
  module V1
    module Models
      module Interactions
        class OrderingInteraction < ChoiceInteraction
          # This will know if a class matches
          def self.matches(node)
            matches = node.xpath('.//xmlns:response_lid')
            return false if matches.count > 1  || matches.empty?
            rcardinality = matches.first.attributes['rcardinality']&.value || 'Single'
            return false if rcardinality != 'Ordered'
            new(node)
          end

          def scoring_data_structs
            correct_order = node.xpath('.//xmlns:varequal').map(&:content)
            correct_order.map { |id| ScoringData.new(id, rcardinality) }
          end
        end
      end
    end
  end
end
