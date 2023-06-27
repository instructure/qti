module Qti
  module V1
    module Models
      module Interactions
        class CategorizationInteraction < BaseInteraction
          def self.matches(node, parent)
            return false if canvas_multiple_fib?(node)
            matches = node.xpath('.//xmlns:response_lid')
            return false if matches.count <= 1
            rcardinality = matches.first.attributes['rcardinality']&.value || 'Single'
            return false if rcardinality != 'Multiple'
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

          def categories
            node.xpath('.//xmlns:response_lid').map do |lid_node|
              mattext = lid_node.at_xpath('.//xmlns:mattext')
              inner_content = return_inner_content!(mattext)
              item_body = sanitize_content!(inner_content)
              category_id = lid_node.attributes['ident'].value
              [category_id, { id: category_id, item_body: item_body }]
            end.to_h
          end

          def distractors
            @distractors ||= choices.reduce({}) do |acc, answer|
              acc.update answer.identifier => answer.item_body
            end
          end

          def scoring_data_structs
            @scoring_data_structs ||= parse_scoring_data
          end

          private

          def parse_scoring_data
            # This preserves the original behavior while not breaking on item feedback
            path = './/xmlns:respcondition/xmlns:setvar/../xmlns:conditionvar/xmlns:varequal'
            raw_scoring_data = node.xpath(path).reduce({}) do |acc, node|
              category_id = node.attributes['respident'].value
              values = (acc[category_id] || []) + [node.text]
              acc.update category_id => values
            end

            raw_scoring_data.map do |id, values|
              Models::ScoringData.new(values, rcardinality, id: id)
            end
          end

          def choices
            @choices ||= answer_nodes.map do |node|
              V1::Models::Choices::LogicalIdentifierChoice.new(node, self)
            end
          end

          def answer_nodes
            responses = []
            response_ids = Set.new
            node.xpath('.//xmlns:response_label').each do |answer_node|
              ident = answer_node.attributes['ident'].value
              responses << answer_node unless response_ids.include? ident
              response_ids << ident
            end
            responses
          end
        end
      end
    end
  end
end
