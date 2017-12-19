module Qti
  module V1
    module Models
      module Interactions
        class NumericInteraction < BaseInteraction
          # This will know if a class matches
          def self.matches(node, parent)
            first_match = node.at_xpath('.//xmlns:render_fib')
            return false unless first_match && first_match.attributes['fibtype']&.value == 'Decimal'
            # exclude types other than "Exact response"
            return false unless node.at_xpath('.//xmlns:varequal').present?
            return false if node.xpath('.//xmlns:render_fib').count > 1
            new(node, parent)
          end

          def item_body
            @item_body ||= begin
              node = @node.dup
              presentation = node.at_xpath('.//xmlns:presentation')
              mattext = presentation.at_xpath('.//xmlns:mattext')
              inner_content = return_inner_content!(mattext)
              sanitize_content!(inner_content)
            end
          end

          def answers
            @answers ||= answer_nodes.map do |node|
              V1::Models::Choices::FillBlankChoice.new(node, self)
            end
          end

          def scoring_data_structs
            answer_nodes.map do |value_node|
              ScoringData.new(
                value_node.content,
                nil,
                id: value_node.attributes['respident']&.value
              )
            end
          end

          private

          def answer_nodes
            @node.xpath('.//xmlns:varequal')
          end
        end
      end
    end
  end
end
