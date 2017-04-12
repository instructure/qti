require 'qti/v1/models/base'
require 'qti/v1/models/interactions'

module Qti
  module V1
    module Models
      class AssessmentItem < Qti::V1::Models::Base
        attr_reader :doc

        def initialize(item)
          @doc = item
        end

        def item_body
          @item_body ||= begin
            node = @doc.dup
            presentation = node.at_xpath('.//xmlns:presentation')
            prompt = presentation.at_xpath('.//xmlns:mattext').content
            sanitize_content!(prompt)
          end
        end

        def identifier
          @identifier ||= @doc.attribute('ident').value
        end

        def title
          @title ||= @doc.attribute('title').value
        end

        def points_possible
          @points_possible ||= begin
            @doc.at_xpath('.//xmlns:decvar/@maxvalue')&.value || @doc.at_xpath('.//xmlns:decvar/@defaultval')&.value
          end
        end

        def rcardinality
          @rcardinality ||= @doc.at_xpath('.//xmlns:response_lid/@rcardinality').value
        end

        def interaction_model
          @interaction_model ||= begin
            V1::Models::Interactions.interaction_model(@doc)
          end
        end

        def scoring_data_structs
          @scoring_data_structs ||= interaction_model.scoring_data_structs
        end
      end
    end
  end
end
