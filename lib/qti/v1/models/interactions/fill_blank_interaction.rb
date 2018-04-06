module Qti
  module V1
    module Models
      module Interactions
        class FillBlankInteraction < BaseFillBlankInteraction
          CANVAS_REGEX = /(\[.+?\])/

          # This will know if a class matches
          def self.matches(node, parent)
            return false if node.at_xpath('.//xmlns:respcondition[@continue!="Yes"]/*/xmlns:other').present?
            match = if BaseInteraction.canvas_multiple_fib?(node)
              node.at_xpath('.//xmlns:response_lid')
            else
              node.at_xpath('.//xmlns:render_fib')
            end
            return false if match.blank? ||
                            match.attributes['fibtype']&.value == 'Decimal'
            new(node, parent)
          end

          def canvas_multiple_fib?
            BaseInteraction.canvas_multiple_fib?(@node)
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
              if stem_item.xpath('./xmlns:render_fib').present?
                stem_blank(index, stem_item.attributes['ident'].value)
              else
                stem_text(index, stem_item.children.text)
              end
            end
          end

          def single_fill_in_blank?
            blanks.count == 1
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
            answer_nodes.map do |value_node|
              ScoringData.new(
                value_node.content,
                rcardinality,
                id: scoring_data_id(value_node),
                case: scoring_data_case(value_node),
                parent_identifier: value_node.parent.parent.attributes['ident']&.value
              )
            end
          end

          private

          def rcardinality
            @rcardinality ||= @node.at_xpath('.//xmlns:response_str/@rcardinality')&.value ||
                              @node.at_xpath('.//xmlns:response_num/@rcardinality')&.value
          end

          def answer_nodes
            if canvas_multiple_fib?
              @node.xpath('.//xmlns:response_label')
            else
              @node.xpath('.//xmlns:varequal')
            end
          end

          def scoring_data_id(node)
            node.attributes['respident']&.value || node.attributes['ident']&.value
          end

          def scoring_data_case(node)
            node.attributes['case']&.value || 'no'
          end
        end
      end
    end
  end
end
