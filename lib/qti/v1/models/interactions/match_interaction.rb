module Qti
  module V1
    module Models
      module Interactions
        class MatchInteraction < BaseInteraction
          def self.matches(node, parent)
            return false if canvas_multiple_fib?(node)
            matches = node.xpath('.//xmlns:response_lid')
            return false if matches.count <= 1
            new(node, parent)
          end

          def answers
            @answers ||= answer_nodes.map do |node|
              V1::Models::Choices::LogicalIdentifierChoice.new(node, self)
            end
          end

          def questions
            node.xpath('.//xmlns:response_lid').map do |lid_node|
              mattext = lid_node.at_xpath('.//xmlns:mattext')
              inner_content = return_inner_content!(mattext)
              item_body = sanitize_content!(inner_content)
              { id: lid_node.attributes['ident'].value, itemBody: item_body }
            end
          end

          def scoring_data_structs
            @scoring_data_structs ||= parse_scoring_data
          end

          def distractors
            correct = scoring_data_structs[0].values.map(&:second)
            all = answers.map(&:item_body)
            all.reject { |v| correct.include? v }
          end

          def scoring_algorithm
            scoring_algorithm_path = './/xmlns:qtimetadatafield/xmlns:fieldlabel' \
            '[text()="scoring_algorithm"]/../xmlns:fieldentry'

            node.at_xpath(scoring_algorithm_path)&.text
          end

          private

          def parse_scoring_data
            # This preserves the original behavior while not breaking on item feedback
            path = './/xmlns:respcondition/xmlns:setvar/../xmlns:conditionvar/xmlns:varequal'
            matches = node.xpath(path).map do |node|
              [node.attributes['respident'].value, answers_map[node.content]]
            end

            [Models::ScoringData.new(Hash[matches], rcardinality)]
          end

          def answers_map
            @answers_map ||= answers.reduce({}) do |acc, answer|
              acc.update answer.identifier => answer.item_body
            end
          end

          def answer_nodes
            responses = []
            response_ids = {}
            node.xpath('.//xmlns:response_label').each do |answer_node|
              ident = answer_node.attributes['ident'].value
              responses << answer_node unless response_ids.key? ident
              response_ids[ident] = 1
            end
            responses
          end
        end
      end
    end
  end
end
