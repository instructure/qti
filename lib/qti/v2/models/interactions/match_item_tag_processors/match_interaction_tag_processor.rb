module Qti
  module V2
    module Models
      module Interactions
        module MatchItemTagProcessors
          class MatchInteractionTagProcessor < Interactions::BaseInteraction
            def self.match_interaction_tag?(node)
              node.xpath('//xmlns:matchInteraction').count == 1
            end

            def self.number_of_questions_per_answer(node)
              correct_categories = node.xpath('.//xmlns:correctResponse//xmlns:value')
                                       .map { |value| value.content.split.last }

              correct_categories.each_with_object(Hash.new(0)) { |category_id, counts| counts[category_id] += 1 }.values
            end

            def questions
              questions_ids.map { |id| { id: id, itemBody: choices_by_identifier[id].content } }
            end

            def shuffled?
              node.at_xpath('.//xmlns:matchInteraction').attributes['shuffle']&.value.try(:downcase) == 'true'
            end

            def answers
              answer_nodes.map { |node| Choices::SimpleAssociableChoice.new(node) }
            end

            def scoring_data_structs
              question_response_pairs.map do |question_id, answer_id|
                content = choices_by_identifier[answer_id].content
                ScoringData.new(content, 'Pair', id: answer_id, question_id: question_id)
              end
            end

            def choices
              node.xpath('.//xmlns:simpleAssociableChoice')
            end

            def question_response_pairs
              node.xpath('.//xmlns:correctResponse//xmlns:value').map do |value|
                value.content.split
              end
            end

            private

            def questions_ids
              @_questions_ids ||= question_response_pairs.map { |question_id, _| question_id }
            end

            def choices_by_identifier
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
end
