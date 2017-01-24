require 'qti/v1/models/base'
require 'qti/v1/models/interactions'

module Qti
  module V1
    module Models
      class AssessmentItem < Qti::V1::Models::Base
        ScoringData = Struct.new(:values, :rcardinality)

        def initialize(item)
          @doc = item
        end

        def item_body
          @item_body ||= begin
            node = @doc.dup
            prompt = node.at_xpath('./presentation/material/mattext').content
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
            @doc.at_xpath('.//decvar/@maxvalue')&.value || @doc.at_xpath('.//decvar/@defaultval')&.value
          end
        end

        def rcardinality
          @rcardinality ||= @doc.at_xpath('.//response_lid/@rcardinality').value
        end

        def interaction_model
          @interaction_model ||= begin
            V1::Models::Interactions.interaction_model(@doc)
          end
        end

        def scoring_data_structs
          @scoring_data_structs ||= begin
            rcardinality = @doc.at_xpath('//response_lid/@rcardinality').value

            choice_nodes = @doc.xpath('.//respcondition')
            value_nodes = []
            # We need to find an action of Set or Add greater than 0 bc there is no correct answer tag
            choice_nodes.each do |choice_node|
              value_nodes << choice_node if choice_node.at_xpath('.//setvar').content.to_f.positive?
            end
            value_nodes.map { |value_node| ScoringData.new(value_node.at_xpath('//varequal').content, rcardinality) }
          end
        end
      end
    end
  end
end
