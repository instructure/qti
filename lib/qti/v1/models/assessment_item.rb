require 'qti/v1/models/base'
require 'qti/v1/models/interactions'

module Qti
  module V1
    module Models
      class AssessmentItem < Qti::V1::Models::Base
        attr_reader :doc

        def initialize(item, package_root = nil)
          @doc = item
          @path = item.document.url
          set_package_root(package_root)
        end

        def item_body
          @item_body ||= begin
            node = @doc.dup
            presentation = node.at_xpath('.//xmlns:presentation')
            prompt = presentation.at_xpath('.//xmlns:mattext').to_html
            sanitize_content!(prompt)
          end
        end

        def identifier
          @identifier ||= @doc.attribute('ident').value
        end

        def title
          @title ||= @doc.attribute('title').value
        end

        def qti_metadata_children
          @doc.at_xpath('.//xmlns:qtimetadata')&.children
        end

        def has_points_possible_qti_metadata?
          if @doc.at_xpath('.//xmlns:qtimetadata').present?
            points_possible_label = qti_metadata_children.children.find {|node| node.text == "points_possible"}
            points_possible_label.present?
          else
            false
          end
        end

        def points_possible
          @points_possible ||= begin
            if has_points_possible_qti_metadata?
              points_possible_label = qti_metadata_children.children.find {|node| node.text == "points_possible"}
              points_possible_node = points_possible_label.next.text
            else
              decvar_maxvalue
            end
          end
        end

        def decvar_maxvalue
          @doc.at_xpath('.//xmlns:decvar/@maxvalue')&.value&.to_i ||
            @doc.at_xpath('.//xmlns:decvar/@defaultval')&.value&.to_i || 0
        end

        def rcardinality
          @rcardinality ||= @doc.at_xpath('.//xmlns:response_lid/@rcardinality').value
        end

        def interaction_model
          @interaction_model ||= begin
            V1::Models::Interactions.interaction_model(@doc, self)
          end
        end

        def scoring_data_structs
          @scoring_data_structs ||= interaction_model.scoring_data_structs
        end
      end
    end
  end
end
