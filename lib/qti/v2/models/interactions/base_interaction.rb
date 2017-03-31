module Qti
  module V2
    module Models
      module Interactions
        class BaseInteraction < Qti::V2::Models::Base
          attr_reader :node

          def self.matches(node)
            false
          end

          def initialize(node)
            @node = node
          end

          def shuffled?
            @node.at_xpath('.//render_choice/@shuffle')&.value == 'Yes'
          end

          def scoring_data_structs
            @scoring_data_structs ||= begin
              type = xpath_with_single_check('//xmlns:responseDeclaration/@baseType').content
              value_nodes = node.xpath('//xmlns:responseDeclaration/xmlns:correctResponse/xmlns:value')
              value_nodes.map { |value_node| Models::ScoringData.new(value_node.content, type) }
            end
          end

          def xpath_with_single_check(xpath)
            node_list = node.xpath(xpath)
            raise Qti::ParseError, 'Too many matches' if node_list.count > 1
            node_list.first
          end

          private

          def rcardinality
            @rcardinality ||= @node.at_xpath('.//response_lid/@rcardinality').value
          end
        end
      end
    end
  end
end
