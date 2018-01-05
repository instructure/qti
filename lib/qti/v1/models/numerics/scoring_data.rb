module Qti
  module V1
    module Models
      module Numerics
        class ScoringData
          class UnsupportedNumreicType < StandardError; end
          def initialize(node)
            @scoring_node = ScoringNode.new(node)
          end

          def scoring_data
            ExactMatch.new(@scoring_node).scoring_data ||
              MarginError.new(@scoring_node).scoring_data ||
              Precision.new(@scoring_node).scoring_data ||
              WithinRange.new(@scoring_node).scoring_data ||
              unknown_type
          end

          def unknown_type
            raise UnsupportedNumreicType, 'Unsupported Numeric Type'
          end
        end
      end
    end
  end
end
