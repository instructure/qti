module Qti
  module V1
    module Models
      module Interactions
        class OrderingInteraction < ChoiceInteraction
          # This will know if a class matches
          def self.matches(node, parent)
            matches = node.xpath('.//xmlns:response_lid')
            return false if matches.count > 1 || matches.empty?
            rcardinality = matches.first.attributes['rcardinality']&.value || 'Single'
            return false if rcardinality != 'Ordered'
            new(node, parent)
          end

          def top_label
            @top_label ||= label_at_position('top')
          end

          def bottom_label
            @bottom_label ||= label_at_position('bottom')
          end

          def scoring_data_structs
            correct_order = node.xpath('.//xmlns:varequal').map(&:content)
            correct_order.map { |id| ScoringData.new(id, rcardinality) }
          end

          def display_answers_paragraph
            render_extension = node.at_xpath('.//xmlns:render_extension')
            ims_render_object = render_extension&.at_xpath('.//xmlns:ims_render_object')

            ims_render_object&.attributes&.[]('orientation')&.value&.downcase == 'row' || false
          end

          private

          def label_at_position(position)
            render_extension = node.at_xpath('.//xmlns:render_extension')
            label_material = render_extension&.at_xpath(".//xmlns:material[@position='#{position}']")
            label_mattext = label_material&.at_xpath('.//xmlns:mattext')

            label_mattext&.content
          end
        end
      end
    end
  end
end
