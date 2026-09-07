module Qti
  module V1
    module Models
      module Interactions
        class BaseInteraction < Qti::V1::Models::Base
          attr_reader :node

          def self.matches(_node, _parent)
            false
          end

          def self.canvas_custom_fitb?(node)
            qtype = question_type(node)
            %w[fill_in_multiple_blanks_question multiple_dropdowns_question].include? qtype
          end

          def self.canvas_multiple_fib?(node)
            matches = node.xpath('.//xmlns:response_lid')
            return false if matches.count < 1
            question_type(node) == 'fill_in_multiple_blanks_question'
          end

          def self.new_quizzes_fib?(node)
            return false unless canvas_multiple_fib?(node)

            first_match = node.at_xpath('.//xmlns:response_label')
            return false if first_match.blank?

            first_match.attr('scoring_algorithm').present?
          end

          def self.question_type(node)
            path = './/xmlns:qtimetadatafield/xmlns:fieldlabel' \
              '[text()="question_type"]/../xmlns:fieldentry'
            node.at_xpath(path)&.text
          end

          def self.maybe_question_type(node, qtype)
            question_type = self.question_type(node)
            !question_type || question_type == qtype
          end

          def initialize(node, parent)
            @node = node
            copy_paths_from_item(parent)
          end

          def shuffled?
            @node.at_xpath('.//xmlns:render_choice/@shuffle')&.value.try(:downcase) == 'yes'
          end

          def locked_choices
            return [] unless shuffled?

            @node.xpath('.//xmlns:response_label').filter_map.with_index do |answer_node, index|
              is_locked = answer_node.attributes['lock']&.value&.downcase == 'yes'

              is_locked ? index : nil
            end
          end

          def scoring_data_structs
            raise NotImplementedError
          end

          def rcardinality
            @rcardinality ||= @node.at_xpath('.//xmlns:response_lid/@rcardinality')&.value || 'Single'
          end

          def canvas_item_feedback
            {
              neutral: get_feedback('general_fb')&.text,
              correct: get_feedback('correct_fb')&.text,
              incorrect: get_feedback('general_incorrect_fb')&.text
            }.compact
          end

          def answer_feedback
            path = './/xmlns:respcondition[xmlns:displayfeedback][.//xmlns:varequal[@respident]]'
            answers = node.xpath(path).map do |entry|
              answer_feedback_entry(entry)
            end.compact
            answers unless answers.empty?
          end

          private

          def answer_feedback_entry(entry)
            ve = entry.xpath('.//xmlns:varequal[@respident]').first
            return nil unless ve
            refid = entry.xpath('./xmlns:displayfeedback[not (@linkrefid="correct_fb" or ' \
              '@linkrefid="general_incorrect_fb" or @linkrefid="general_fb")]').first&.[](:linkrefid)
            feedback = get_feedback(refid)
            return nil unless feedback
            answer = {
              response_id: ve[:respident],
              response_value: ve.text,
              texttype: feedback&.[](:texttype),
              feedback: feedback&.text
            }
            answer[:negated] = true if negated_condition?(ve)
            answer
          end

          # Matching is the one Canvas type whose comment is shown when the
          # student did *not* pick that match, so its `varequal` sits inside a
          # `not`. Report that, rather than making the consumer infer it from
          # the question type -- third party QTI may emit either form for any
          # type. Only set when true, so every other type keeps its old shape.
          def negated_condition?(varequal)
            varequal.ancestors.take_while { |a| a.name != 'respcondition' }
                    .count { |a| a.name == 'not' }.odd?
          end

          def get_feedback(ident)
            node.xpath(".//xmlns:itemfeedback[@ident='#{ident}']/xmlns:*/xmlns:*/xmlns:mattext").first
          end
        end
      end
    end
  end
end
