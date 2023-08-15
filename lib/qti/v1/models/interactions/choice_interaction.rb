module Qti
  module V1
    module Models
      module Interactions
        class ChoiceInteraction < BaseInteraction
          # This will know if a class matches
          def self.matches(node, parent)
            return false unless maybe_choice_type(node)
            matches = node.xpath('.//xmlns:response_lid')
            return false if matches.count > 1 || matches.empty?
            rcardinality = matches.first.attributes['rcardinality']&.value || 'Single'
            return false if rcardinality == 'Ordered'
            new(node, parent)
          end

          def self.maybe_choice_type(node)
            question_type = self.question_type(node)
            return true unless question_type
            valid_types = %w[multiple_choice_question multiple_answers_question true_false_question]
            valid_types.include?(question_type)
          end

          def answers
            @answers ||= answer_nodes.map do |node|
              V1::Models::Choices::LogicalIdentifierChoice.new(node, self)
            end
          end

          def meta_type
            meta_node = node.at_xpath(
              './/xmlns:qtimetadatafield[./xmlns:fieldlabel/text()="question_type"]'
            )
            return nil unless meta_node.present?
            type_node = meta_node.at_xpath('.//xmlns:fieldentry')
            type_node&.text()
          end

          def scoring_data_structs
            choice_nodes = node.xpath('.//xmlns:respcondition')
            if choice_nodes.at_xpath('.//xmlns:and').present?
              scoring_data_condition(choice_nodes)
            else
              scoring_data(choice_nodes)
            end
          end

          def scoring_algorithm
            scoring_algorithm_path = './/xmlns:qtimetadatafield/xmlns:fieldlabel' \
            '[text()="scoring_algorithm"]/../xmlns:fieldentry'

            node.at_xpath(scoring_algorithm_path)&.text
          end

          private

          def answer_nodes
            node.xpath('.//xmlns:response_label')
          end

          def scoring_data_condition(choice_nodes)
            answer_choices = choice_nodes.at_xpath('.//xmlns:and')
            answer_choices.children.filter('not').each(&:remove)
            answer_choices.children.map do |value_node|
              ScoringData.new(value_node.content, rcardinality)
            end
          end

          # rubocop:disable Metrics/AbcSize
          def scoring_data(choice_nodes)
            setvar_nodes(choice_nodes).map do |value_node|
              scoring_options = {}
              scoring_options['points'] = value_node.at_xpath('.//xmlns:setvar')&.content&.to_f

              if value_node.attributes['correctanswer']&.value&.downcase == 'yes'
                scoring_options['correct_answer'] = true
              end

              ScoringData.new(value_node.at_xpath('.//xmlns:varequal').content, rcardinality,
                scoring_options: scoring_options)
            end
          end

          # rubocop:enable Metrics/AbcSize
          def setvar_nodes(choice_nodes)
            choice_nodes.select do |choice_node|
              choice_node.at_xpath('.//xmlns:setvar')&.content&.to_f&.positive?
            end
          end
        end
      end
    end
  end
end
