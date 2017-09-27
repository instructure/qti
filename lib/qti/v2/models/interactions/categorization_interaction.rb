require_relative 'match_interaction'

module Qti
  module V2
    module Models
      module Interactions
        class CategorizationInteraction < MatchInteraction
          def self.matches(node, parent)
            if use_match_interaction_implementation?(node)
              new(node, parent, MatchItemTagProcessors::MatchInteractionTagProcessor)
            else
              false
            end
          end

          def self.use_match_interaction_implementation?(node)
            MatchItemTagProcessors::MatchInteractionTagProcessor.match_interaction_tag?(node) &&
              MatchItemTagProcessors::MatchInteractionTagProcessor.number_of_questions_per_answer(node)
                                                                  .any? { |n| n != 1 }
          end

          def scoring_data_structs
            questions_categories_choices_hash.map do |category_choice, questions_choices|
              ScoringData.new(category_choice.text, 'directedPair',
                id: node_identifier(category_choice),
                questions_ids: questions_choices.map { |q| node_identifier(q) })
            end
          end

          private

          def questions_categories_choices_hash
            category_choices.each_with_object({}) do |category_choice, hash|
              hash[category_choice] = questions_for_category_choice(category_choice)
            end
          end

          def questions_for_category_choice(choice)
            choice_identifier = node_identifier(choice)
            category_questions_ids = implementation.question_response_pairs
                                                   .select { |_, category_id| category_id == choice_identifier }
                                                   .map { |question_id, _| question_id }
            question_choices.select { |q| category_questions_ids.include? node_identifier(q) }
          end

          def category_choices
            @_category_choices ||= implementation.choices.select { |c| categories_ids.include? node_identifier(c) }
          end

          def question_choices
            @_question_choices ||= implementation.choices.select { |c| questions_ids.include? node_identifier(c) }
          end

          def categories_ids
            @_categories_ids ||= implementation.question_response_pairs.map { |_, category_id| category_id }.uniq
          end

          def questions_ids
            @_questions_ids ||= implementation.question_response_pairs.map { |question_id, _| question_id }.uniq
          end

          def node_identifier(node)
            node.attributes['identifier'].value
          end
        end
      end
    end
  end
end
