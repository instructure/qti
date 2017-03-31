module Qti
  module V2
    module Models
      module Interactions
        class MatchInteraction < BaseInteraction
          def self.matches(node)
            matches = node.xpath('//xmlns:matchInteraction')
            return false if matches.empty?

            raise Qti::UnsupportedSchema if matches.size > 1
            new(node)
          end

          def questions
            node.xpath('.//xmlns:correctResponse//xmlns:value')
                .map { |value| value.content.split.first }
                .map { |id| { id: id, question_body: choices_by_identifier[id].content } }
          end

          def answers
            answer_nodes.map { |node| Choices::SimpleAssociableChoice.new(node) }
          end

          def scoring_data_structs
            question_response_pairs = node.xpath('.//xmlns:correctResponse//xmlns:value').map do |value|
              value.content.split
            end
            question_response_id_mapping = Hash[question_response_pairs]
            data = question_response_id_mapping.reduce({}) do |acc, pair|
              question_id, answer_id = pair
              acc.update question_id => choices_by_identifier[answer_id].content
            end
            [ScoringData.new(data, 'directedPair')]
          end

          private

          def choices_by_identifier
            choices = node.xpath('.//xmlns:simpleAssociableChoice')
            @choices_by_identifier ||= choices.reduce({}) do |acc, choice|
              acc.update choice.attributes['identifier'].value => choice
            end
          end

          def answer_nodes
            node.xpath('.//xmlns:matchInteraction//xmlns:simpleMatchSet[2]//xmlns:simpleAssociableChoice')
          end
        end
      end
    end
  end
end
