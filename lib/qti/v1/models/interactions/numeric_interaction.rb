module Qti
  module V1
    module Models
      module Interactions
        class NumericInteraction < BaseInteraction
          # This will know if a class matches
          def self.matches(node, parent)
            first_match = node.at_xpath('.//xmlns:render_fib')
            return false unless first_match && first_match.attributes['fibtype']&.value == 'Decimal'
            return false if node.xpath('.//xmlns:render_fib').count > 1
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

          def scoring_data_structs
            answer_nodes.map do |value_node|
              V1::Models::Numerics::ScoringData.new(
                value_node
              ).scoring_data
            end
          end

          # Numeric answers cannot be paired with their comment through a
          # `varequal`, the way the base implementation does it: exact and
          # precision answers nest it inside an `or`, and range answers have no
          # single value to emit one for. Canvas instead puts each answer's
          # `displayfeedback` in the same `respcondition` that carries its
          # `setvar SCORE`, so pair them by that node and key the result on the
          # position within `answer_nodes` -- the same list, in the same order,
          # that `scoring_data_structs` is built from.
          def answer_feedback
            answers = answer_nodes.filter_map.with_index do |answer_node, index|
              numeric_answer_feedback_entry(answer_node, index)
            end
            answers unless answers.empty?
          end

          private

          def numeric_answer_feedback_entry(answer_node, index)
            refid = answer_node.xpath('./xmlns:displayfeedback[not (@linkrefid="correct_fb" or ' \
              '@linkrefid="general_incorrect_fb" or @linkrefid="general_fb")]').first&.[](:linkrefid)
            feedback = get_feedback(refid)
            return nil unless feedback
            {
              response_index: index,
              texttype: feedback[:texttype],
              feedback: feedback.text
            }
          end

          def answer_nodes
            @node.xpath('.//xmlns:respcondition/xmlns:setvar[@varname="SCORE"]/..')
          end
        end
      end
    end
  end
end
