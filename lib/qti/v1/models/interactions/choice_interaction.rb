module Qti
  module V1
    module Models
      module Interactions
        class ChoiceInteraction < BaseInteraction
          # This will know if a class matches
          def self.matches(node, parent)
            matches = node.xpath('.//xmlns:response_lid')
            return false if matches.count > 1  || matches.empty?
            rcardinality = matches.first.attributes['rcardinality']&.value || 'Single'
            return false if rcardinality == 'Ordered'
            new(node, parent)
          end

          def answers
            @answers ||= answer_nodes.map do |node|
              V1::Models::Choices::LogicalIdentifierChoice.new(node, self)
            end
          end

          def scoring_data_structs
            choice_nodes = node.xpath('.//xmlns:respcondition')
            if choice_nodes.at_xpath('.//xmlns:and').present?
              answer_choices = choice_nodes.at_xpath('.//xmlns:and')
              answer_choices.children.filter('not').each(&:remove)
              answer_choices.children.map { |value_node| ScoringData.new(value_node.content, rcardinality) }
            else
              set_var_nodes = choice_nodes.select { |choice_node| choice_node.at_xpath('.//xmlns:setvar')&.content&.to_f&.positive? }
              set_var_nodes.map { |value_node| ScoringData.new(value_node.at_xpath('.//xmlns:varequal').content, rcardinality) }
            end
          end

          private

          def answer_nodes
            node.xpath('.//xmlns:response_label')
          end
        end
      end
    end
  end
end
