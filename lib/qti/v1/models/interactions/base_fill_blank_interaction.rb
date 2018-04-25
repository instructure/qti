module Qti
  module V1
    module Models
      module Interactions
        class BaseFillBlankInteraction < BaseInteraction
          CANVAS_REGEX ||= /(\[.+?\])/

          def canvas_stem_items(item_prompt)
            item_prompt.split(CANVAS_REGEX).map.with_index do |stem_item, index|
              if stem_item.match CANVAS_REGEX
                stem_blank(index, canvas_blank_id(stem_item))
              else
                stem_text(index, stem_item)
              end
            end
          end

          def stem_blank(index, value)
            {
              id: "stem_#{index}",
              position: index + 1,
              type: 'blank',
              blank_id: value
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

          def canvas_blank_id(stem_item)
            blank_id = nil
            node.xpath('.//xmlns:response_lid').children.map do |response_lid_node|
              if stem_item.include?(response_lid_node.text)
                blank_id = response_lid_node.parent.attributes['ident']&.value
              end
            end
            blank_id
          end
        end
      end
    end
  end
end
