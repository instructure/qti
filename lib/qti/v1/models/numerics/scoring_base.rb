module Qti
  module V1
    module Models
      module Numerics
        class ScoringBase
          def initialize(scoring_node)
            @scoring_node = scoring_node
          end

          def equal_node
            @scoring_node.equal_node
          end

          def gte_node
            @scoring_node.gte_node
          end

          def lte_node
            @scoring_node.lte_node
          end

          def gt_node
            @scoring_node.gt_node
          end
        end
      end
    end
  end
end
