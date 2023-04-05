module Qti
  module V1
    module Models
      module Interactions
        class BaseFillBlankInteraction < BaseInteraction
          def canvas_stem_items(item_prompt)
            item_prompt = sanitize_attributes(item_prompt)
            item_prompt.split(CANVAS_BLANK_REGEX).map.with_index do |stem_item, index|
              if canvas_fib_response_ids.include?(stem_item)
                # Strip the brackets before searching
                value = stem_item[1..-2]
                blank_id = blank_id(value)
                blank_name = blank_value(blank_id) || value
                stem_blank(index, blank_id, blank_name)
              else
                stem_text(index, stem_item)
              end
            end
          end

          def stem_blank(index, blank_id, blank_name)
            {
              id: "stem_#{index}",
              position: index + 1,
              type: 'blank',
              blank_id: blank_id,
              blank_name: blank_name
            }
          end

          def stem_text(index, value)
            {
              id: "stem_#{index}",
              position: index + 1,
              type: 'text',
              value: value
            }
          end

          def blank_id(stem_item)
            return stem_item unless canvas_custom_fitb?
            canvas_blank_id(stem_item)
          end

          def blank_value(blank_id)
            blank = canvas_fib_responses.find { |response| response[:id] == blank_id }
            blank&.dig(:choices, 0, :item_body)
          end

          def canvas_custom_fitb?
            @canvas_custom_fitb ||= BaseInteraction.canvas_custom_fitb?(@node)
          end

          def canvas_blank_id(stem_item)
            blank_id = nil
            node.xpath('.//xmlns:response_lid/xmlns:material').children.map do |response_lid_node|
              if stem_item == response_lid_node.text
                blank_id = response_lid_node.ancestors('response_lid').first.attributes['ident']&.value
              end
            end
            blank_id
          end

          def canvas_fib_responses
            @base_canvas_blanks ||= node.xpath('.//xmlns:response_lid').map do |resp|
              index = 0
              {
                id: resp[:ident],
                choices:
                  resp.xpath('.//xmlns:response_label').map do |bnode|
                    canvas_blank_choice(bnode, index += 1)
                  end
              }
            end
            @base_canvas_blanks
          end

          def canvas_fib_response_ids
            @canvas_fib_response_ids ||= canvas_fib_responses.map { |b| "[#{b[:id].sub(/^response_/, '')}]" }
          end

          private

          def canvas_blank_choice(bnode, index)
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
