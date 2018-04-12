module Qti
  module V1
    module Models
      module Interactions
        class BaseInteraction < Qti::V1::Models::Base
          attr_reader :node

          def self.matches(_node, _parent)
            false
          end

          def self.canvas_multiple_fib?(node)
            matches = node.xpath('.//xmlns:response_lid')
            return false if matches.count <= 1
            node.at_xpath('.//xmlns:fieldentry').text == 'fill_in_multiple_blanks_question'
          end

          def initialize(node, parent)
            @node = node
            copy_paths_from_item(parent)
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
