module Qti
  module V1
    module Models
      module Interactions
        class FillBlankInteraction < BaseFillBlankInteraction
          # This will know if a class matches
          def self.matches(node, parent)
            return false if node.at_xpath('.//xmlns:respcondition[@continue!="Yes"]/*/xmlns:other').present?

            match, answers = FillBlankInteraction.match_and_answers(node)
            return false if answers.blank?
            return false if match.blank? || match.attributes['fibtype']&.value == 'Decimal'
            new(node, parent)
          end

          def self.match_and_answers(node)
            if BaseInteraction.canvas_multiple_fib?(node)
              return [
                node.at_xpath('.//xmlns:response_lid'),
                node.xpath('.//xmlns:response_label')
              ]
            end
            [
              node.at_xpath('.//xmlns:render_fib'),
              node.xpath('.//xmlns:respcondition/xmlns:setvar/../xmlns:conditionvar/xmlns:varequal')
            ]
          end

          def canvas_multiple_fib?
            @canvas_multiple_fib ||= BaseInteraction.canvas_multiple_fib?(@node)
          end

          def new_quizzes_fib?
            @new_quizzes_fib ||= BaseInteraction.new_quizzes_fib?(@node)
          end

          def stem_items
            if canvas_multiple_fib?
              canvas_stem_items(node.at_xpath('.//xmlns:mattext').text)
            else
              qti_stem_items
            end
          end

          def qti_stem_items
            stem_item_nodes = node.xpath('.//xmlns:presentation').children
            stem_item_nodes.map.with_index do |stem_item, index|
              qti_stem_item(index, stem_item)
            end
          end

          def single_fill_in_blank?
            !canvas_multiple_fib? && blanks.count == 1
          end

          def blanks
            if node.at_xpath('.//xmlns:render_choice').present?
              canvas_blanks
            else
              qti_standard_blanks
            end
          end

          def canvas_blanks
            node.xpath('.//xmlns:response_label').map do |blank|
              { id: blank.attributes['ident']&.value }
            end
          end

          def qti_standard_blanks
            node.xpath('.//xmlns:response_str').map do |blank|
              { id: blank.attributes['ident']&.value }
            end
          end

          def answers
            @answers ||= answer_nodes.map do |node|
              V1::Models::Choices::FillBlankChoice.new(node, self)
            end
          end

          def scoring_data_structs
            @scoring_data_structs ||= answer_nodes.map do |value_node|
              ScoringData.new(
                value_node.content,
                rcardinality,
                id: scoring_data_id(value_node),
                case: scoring_data_case(value_node),
                parent_identifier: value_node.parent.parent.attributes['ident']&.value,
                scoring_algorithm: scoring_data_algorithm(value_node),
                answer_type: scoring_data_answer_type(value_node),
                scoring_options: scoring_data_options(value_node)
              )
            end
          end

          def wordbank_answer_present?
            return false unless first_wordbank_answer

            true
          end

          def wordbank_allow_reuse?
            return unless wordbank_answer_present?

            wordbank_struct = scoring_data_structs.find { |struct| struct.answer_type == 'wordbank' }
            return false unless wordbank_struct.scoring_options['allow_reuse'] == 'true'

            true
          end

          def wordbank_choices
            return unless wordbank_answer_present?

            choices = Set.new

            wordbank_answers = all_wordbank_answers.map do |node|
              V1::Models::Choices::FillBlankChoice.new(node, self)
            end

            wordbank_answers.each do |wordbank_answer|
              choices.add({ id: wordbank_answer.identifier, item_body: wordbank_answer.item_body })
            end

            choices.to_a
          end

          def correct_answer_map
            @correct_answer_map ||= super
          end

          private

          def rcardinality
            @rcardinality ||= @node.at_xpath('.//xmlns:response_str/@rcardinality')&.value ||
                              @node.at_xpath('.//xmlns:response_num/@rcardinality')&.value
          end

          def answer_nodes
            if canvas_multiple_fib?
              node.xpath('.//xmlns:response_label')
            else
              node.xpath('.//xmlns:respcondition/xmlns:setvar/../xmlns:conditionvar/xmlns:varequal')
            end
          end

          def scoring_data_id(node)
            node.attributes['respident']&.value || node.attributes['ident']&.value
          end

          def scoring_data_case(node)
            node.attributes['case']&.value || 'no'
          end

          def scoring_data_algorithm(node)
            node.attributes['scoring_algorithm']&.value || 'TextInChoices'
          end

          def scoring_data_answer_type(node)
            node.attributes['answer_type']&.value || 'openEntry'
          end

          def scoring_data_options(node)
            options = {}
            algorithm = scoring_data_algorithm(node)
            type = scoring_data_answer_type(node)

            if algorithm == 'TextCloseEnough'
              options['levenshtein_distance'] = levenshtein_distance(node)
              options['ignore_case'] = ignore_case(node)
            end

            options['allow_reuse'] = node.attributes['allow_reuse']&.value if type == 'wordbank'

            options
          end

          def levenshtein_distance(node)
            node.attributes['levenshtein_distance']&.value || '1'
          end

          def ignore_case(node)
            node.attributes['ignore_case']&.value || 'false'
          end

          def first_wordbank_answer
            @first_wordbank_answer ||= answer_nodes.find { |node| scoring_data_answer_type(node) == 'wordbank' }
          end

          def all_wordbank_answers
            @all_wordbank_answers ||= answer_nodes.find_all { |node| scoring_data_answer_type(node) == 'wordbank' }
          end

          def qti_stem_item(index, stem_item)
            if stem_item.xpath('./xmlns:render_fib').present?
              blank_id = stem_item.attributes['ident'].value
              blank_answer = answers.find { |answer| answer.identifier == blank_id }
              blank_name = blank_answer&.item_body || blank_id
              stem_blank(index, blank_id, blank_name)
            else
              stem_text(index, sanitize_content!(stem_item.children.text))
            end
          end
        end
      end
    end
  end
end
