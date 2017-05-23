module Qti
  module V2
    module Models
      module Interactions
        class ChoiceInteraction < BaseInteraction
          def self.matches(node)
            matches = node.xpath('.//xmlns:choiceInteraction')
            return false if matches.empty?

            raise Qti::UnsupportedSchema if matches.size > 1
            new(matches.first)
          end

          def answers
            @answers ||= answer_nodes.map do |node|
              V2::Models::Choices::SimpleChoice.new(node)
            end
          end

          def max_choices_count
            @node.attributes['maxChoices']&.value&.to_i
          end

          def min_choices_count
            @node.attributes['minChoices']&.value&.to_i
          end

          private

          def answer_nodes
            @node.xpath('.//xmlns:simpleChoice')
          end
        end
      end
    end
  end
end
