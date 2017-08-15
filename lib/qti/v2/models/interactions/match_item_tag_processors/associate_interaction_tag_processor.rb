module Qti
  module V2
    module Models
      module Interactions
        module MatchItemTagProcessors
          class AssociateInteractionTagProcessor < Interactions::BaseInteraction
            def self.associate_interaction_tag?(node)
              node.xpath('.//xmlns:associateInteraction').count == 1
            end

            def self.number_of_questions_per_answer(node)
              question_response_pairs = node.xpath('.//xmlns:correctResponse//xmlns:value').map do |value|
                value.content.split
              end
              count = Hash.new { 0 }
              question_response_pairs.reduce(count) do |acc, pair|
                acc.update pair.last => acc[pair.last] + 1
              end
              count.values
            end

            def shuffled?
              node.at_xpath('.//xmlns:associateInteraction').attributes['shuffle']&.value.try(:downcase) == 'true'
            end

            def questions
              questions_ids.map { |id| { id: id, itemBody: choices_by_identifier[id].content } }
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

            private

            def choices_by_identifier
              @_choices_by_identifier ||= choices.reduce({}) do |acc, choice|
                acc.update choice.attributes['identifier'].value => choice
              end
            end

            def answer_nodes
              @_answer_nodes ||= choices.select { |c| answer_ids.include?(c.attributes['identifier'].value) }
            end

            def questions_ids
              @_questions_ids ||= question_response_pairs.map { |question_id, _| question_id }
            end

            def answer_ids
              @_answer_ids ||= question_response_pairs.map { |_, answer_id| answer_id }
            end

            def choices
              node.xpath('.//xmlns:simpleAssociableChoice')
            end

            def question_response_pairs
              node.xpath('.//xmlns:correctResponse//xmlns:value').map do |value|
                value.content.split
              end
            end
          end
        end
      end
    end
  end
end
