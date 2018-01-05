require 'qti/v1/models/numerics/scoring_base'

module Qti
  module V1
    module Models
      module Numerics
        class ExactMatch < ScoringBase
          def initialize(scoring_node)
            super(scoring_node)
          end

          def scoring_data
            return unless valid?
            Struct.new(
              :id,
              :type,
              :value
            ).new(
              equal_node.attributes['respident']&.value,
              'exactResponse',
              equal_node.content
            )
          end

          private

          def valid?
            node_complete? && content_consistent?
          end

          def node_complete?
            (equal_node && gte_node && lte_node).present?
          end

          def content_consistent?
            equal_node.content == gte_node.content &&
              equal_node.content == lte_node.content
          end
        end
      end
    end
  end
end
