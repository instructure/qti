module Qti
  module V1
    module Models
      module Numerics
        class ScoringNode
          def initialize(node)
            @node = node
          end

          def equal_node
            @_equal_node ||= @node.at_xpath('.//xmlns:varequal')
          end

          def gte_node
            @_gte_node ||= @node.at_xpath('.//xmlns:vargte')
          end

          def lte_node
            @_lte_node ||= @node.at_xpath('.//xmlns:varlte')
          end

          def gt_node
            @_gt_node ||= @node.at_xpath('.//xmlns:vargt')
          end
        end
      end
    end
  end
end
