module Qti
  module V1
    module Models
      module Numerics
        class WithinRange < ScoringBase
          def initialize(scoring_node)
            super(scoring_node)
          end

          def scoring_data
            return unless valid?
            Struct.new(
              :id,
              :type,
              :start,
              :end
            ).new(
              gte_node.attributes['respident']&.value,
              'withinARange',
              gte_node.content,
              lte_node.content
            )
          end

          private

          def valid?
            (gte_node && lte_node).present? && equal_node.nil?
          end
        end
      end
    end
  end
end
