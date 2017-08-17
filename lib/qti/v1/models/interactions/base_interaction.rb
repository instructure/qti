module Qti
  module V1
    module Models
      module Interactions
        class BaseInteraction < Qti::V1::Models::Base
          attr_reader :node

          def self.matches(node, parent)
            false
          end

          def initialize(node, parent)
            @node = node
            set_paths_from_item(parent)
          end

          def shuffled?
            @node.at_xpath('.//xmlns:render_choice/@shuffle')&.value.try(:downcase) == 'yes'
          end

          def scoring_data_structs
            raise NotImplementedError
          end

          def rcardinality
            @rcardinality ||= @node.at_xpath('.//xmlns:response_lid/@rcardinality')&.value || 'Single'
          end
        end
      end
    end
  end
end
