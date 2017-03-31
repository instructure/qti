module Qti
  module V1
    module Models
      module Interactions
        class ChoiceInteraction < BaseInteraction
          # This will know if a class matches
          def self.matches(node)
            matches = node.xpath('.//response_lid')
            return false if matches.count > 1
            rcardinality = matches.first.attributes['rcardinality'].value
            return false if rcardinality == 'Ordered'
            new(node)
          end

          def initialize(node)
            @node = node
          end

          def shuffled?
            node.at_xpath('.//render_choice/@shuffle')&.value == 'Yes'
          end

          def answers
            @answers ||= answer_nodes.map do |node|
              V1::Models::Choices::LogicalIdentifierChoice.new(node)
            end
          end

          def scoring_data_structs
            choice_nodes = node.xpath('.//respcondition')
            choice_nodes.select { |choice_node| choice_node.at_xpath('.//setvar').content.to_f.positive? }
                        .map { |value_node| ScoringData.new(value_node.at_xpath('.//varequal').content, rcardinality) }
          end

          private

          def answer_nodes
            node.xpath('.//response_label')
          end
        end
      end
    end
  end
end
