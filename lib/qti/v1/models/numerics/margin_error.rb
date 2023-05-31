module Qti
  module V1
    module Models
      module Numerics
        class MarginError < ScoringBase
          def scoring_data
            return unless valid?
            Struct.new(
              :id,
              :type,
              :value,
              :margin,
              :margin_type
            ).new(
              equal_node.attributes['respident']&.value,
              'marginOfError',
              equal_node.content.to_f.to_s,
              margin,
              margin_type
            )
          end

          private

          def margin
            equal_node.attributes['margin']&.value ||
              (equal_node.content.to_f - gte_node.content.to_f).to_s
          end

          def margin_type
            equal_node.attributes['margintype']&.value || 'absolute'
          end

          def valid?
            node_complete? && content_consistent?
          end

          def node_complete?
            (equal_node && gte_node && lte_node).present?
          end

          def content_consistent?
            equal_node.content != gte_node.content &&
              equal_node.content != lte_node.content
          end
        end
      end
    end
  end
end
