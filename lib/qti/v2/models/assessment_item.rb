require 'qti/v2/models/base'
require 'qti/v2/models/interactions'

module Qti
  module V2
    module Models
      class AssessmentItem < Qti::V2::Models::Base
        ScoringData = Struct.new(:values, :type)

        def item_body
          @item_body ||= begin
            node = item_body_node.dup
            # ensure a prompt is carried into the html
            prompt = node.at_xpath('//xmlns:prompt')

            # Filter undesired interaction nodes out of the list (need to make this a deep traversal)
            node.children.filter(INTERACTION_ELEMENTS_CSS).map(&:unlink)

            node.add_child(prompt) if prompt&.parent && prompt.parent != node
            sanitize_content!(node.to_html)
          end
        end

        # Not used yet
        def identifier
          @identifier ||= xpath_with_single_check('//xmlns:assessmentItem/@identifier').content
        end

        def title
          @title ||= xpath_with_single_check('//xmlns:assessmentItem/@title').content
        end

        def points_possible
          @points_possible ||= begin
            xpath_with_single_check("//xmlns:outcomeDeclaration[@identifier='SCORE']/@normalMaximum")&.content ||
            xpath_with_single_check("//xmlns:outcomeDeclaration[@identifier='MAXSCORE']//xmlns:value")&.content
          end
        end

        def interaction_model
          @interaction_model ||= begin
            V2::Models::Interactions.interaction_model(item_body_node)
          end
        end

        def scoring_data_structs
          @scoring_data_structs ||= begin
            type = xpath_with_single_check('//xmlns:responseDeclaration/@baseType').content
            value_nodes = @doc.xpath('//xmlns:responseDeclaration/xmlns:correctResponse/xmlns:value')
            value_nodes.map { |value_node| ScoringData.new(value_node.content, type) }
          end
        end

        private

        def item_body_node
          @item_body_node ||= xpath_with_single_check('//xmlns:itemBody')
        end
      end
    end
  end
end
