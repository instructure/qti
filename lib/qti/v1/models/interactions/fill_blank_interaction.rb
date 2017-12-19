module Qti
  module V1
    module Models
      module Interactions
        class FillBlankInteraction < BaseInteraction
          # This will know if a class matches
          def self.matches(node, parent)
            return false if node.xpath('.//xmlns:other').present?
            matches = node.xpath('.//xmlns:render_fib')
            return false if matches.empty? ||
              matches.first.attributes['fibtype']&.value == 'Decimal'
            new(node, parent)
          end

          def stem_items
            stem_item_nodes = node.xpath('.//xmlns:presentation').children
            stem_item_nodes.map.with_index do |stem_item, index|
              if stem_item.xpath('./xmlns:render_fib').present?
                {
                  id: "stem_#{index}",
                  position: index + 1,
                  type: 'blank',
                  blank_id: stem_item.attributes['ident'].value
                }
              else
                {
                  id: "stem_#{index}",
                  position: index + 1,
                  type: 'text',
                  value: stem_item.children.text
                }
              end
            end
          end

          def single_fill_in_blank?
            blanks.count == 1
          end

          def blanks
            node.xpath('.//xmlns:response_str').map do |blank|
              { id: blank.attributes['ident'].value }
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
                id: value_node.attributes['respident']&.value,
                case: value_node.attributes['case']&.value || 'no'
              )
            end
          end

          private

          def rcardinality
            @rcardinality ||= @node.at_xpath('.//xmlns:response_str/@rcardinality')&.value ||
                              @node.at_xpath('.//xmlns:response_num/@rcardinality')&.value
          end

          def answer_nodes
            @node.xpath('.//xmlns:varequal')
          end
        end
      end
    end
  end
end
