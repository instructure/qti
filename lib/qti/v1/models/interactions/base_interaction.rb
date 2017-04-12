module Qti
  module V1
    module Models
      module Interactions
        class BaseInteraction < Qti::V1::Models::Base
          attr_reader :node

          def self.matches(node)
            false
          end

          def initialize(node)
            @node = node
          end

          def shuffled?
            @node.at_xpath('.//xmlns:render_choice/@shuffle')&.value == 'Yes'
          end

          def scoring_data_structs
            raise NotImplementedError
          end

          private

          def rcardinality
            @rcardinality ||= @node.at_xpath('.//xmlns:response_lid/@rcardinality').value
          end
        end
      end
    end
  end
end
