module Qti
  module V1
    module Models
      module Interactions
        class CanvasMultipleDropdownInteraction < BaseFillBlankInteraction
          # This will know if a class matches
          def self.matches(node, parent)
            field_entry = node.xpath('.//xmlns:fieldentry')[0]
            return false unless field_entry&.text == 'multiple_dropdowns_question'
            new(node, parent)
          end

          def stem_items
            canvas_stem_items(node.at_xpath('.//xmlns:presentation/xmlns:material/xmlns:mattext').text)
          end

          def blanks
            @blanks = node.xpath('.//xmlns:response_lid').map do |resp|
              index = 0
              {
                id: resp[:ident],
                choices:
                  resp.xpath('.//xmlns:response_label').map do |bnode|
                    blank_choice(bnode, index += 1)
                  end
              }
            end
          end

          def scoring_data_structs
            answers.map do |answer|
              ScoringData.new(
                {
                  id: answer[:entry_id],
                  position: position_for_entry(answer[:entry_id]),
                  item_body: answer[:blank_text]
                },
                rcardinality,
                id: answer[:value]
              )
            end
          end

          def text_for_entry(entry_id)
            blanks
            @blank_choices[entry_id][:item_body]
          end

          def position_for_entry(entry_id)
            blanks
            @blank_choices[entry_id][:position]
          end

          def answers
            @node.xpath('.//xmlns:respcondition/xmlns:setvar[@varname="SCORE"]').map do |points|
              entry = points.at_xpath('preceding-sibling::xmlns:conditionvar/xmlns:varequal')
              {
                value: entry[:respident],
                entry_id: entry.text,
                blank_text: text_for_entry(entry.text),
                action: points[:action],
                point_value: points.text
              }
            end
          end

          private

          def blank_choice(bnode, index)
            bnode_id = bnode[:ident]
            choice = {
              id: bnode_id,
              position: index + 1,
              item_body: bnode.at_xpath('.//xmlns:mattext').text
            }
            @blank_choices ||= {}
            @blank_choices[bnode_id] = choice
            choice
          end
        end
      end
    end
  end
end
