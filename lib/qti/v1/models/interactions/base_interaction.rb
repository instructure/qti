module Qti
  module V1
    module Models
      module Interactions
        class BaseInteraction < Qti::V1::Models::Base
          attr_reader :node

          def self.matches(_node, _parent)
            false
          end

          def self.canvas_multiple_fib?(node)
            matches = node.xpath('.//xmlns:response_lid')
            return false if matches.count <= 1
            node.at_xpath('.//xmlns:fieldentry').text == 'fill_in_multiple_blanks_question'
          end

          def initialize(node, parent)
            @node = node
            copy_paths_from_item(parent)
          end

          def shuffled?
            @node.at_xpath('.//xmlns:render_choice/@shuffle')&.value.try(:downcase) == 'yes'
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
            path = './/xmlns:respcondition//xmlns:displayfeedback/../' \
              'xmlns:conditionvar/xmlns:varequal[@respident]/../../' \
              'xmlns:displayfeedback/..'
            answers = node.xpath(path).map do |entry|
              answer_feedback_entry(entry)
            end
            answers unless answers.empty?
          end

          private

          def answer_feedback_entry(entry)
            ve = entry.xpath('.//xmlns:varequal').first
            refid = entry.xpath('./xmlns:displayfeedback').first[:linkrefid]
            feedback = get_feedback(refid)
            {
              response_id: ve[:respident],
              response_value: ve.text,
              texttype: feedback[:texttype],
              feedback: feedback.text
            }
          end

          def get_feedback(ident)
            node.xpath(".//xmlns:itemfeedback[@ident='#{ident}']/xmlns:*/xmlns:*/xmlns:mattext").first
          end
        end
      end
    end
  end
end
