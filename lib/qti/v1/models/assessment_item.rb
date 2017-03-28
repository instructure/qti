require 'qti/v1/models/base'
require 'qti/v1/models/interactions'

module Qti
  module V1
    module Models
      class AssessmentItem < Qti::V1::Models::Base
        attr_reader :doc

        ScoringData = Struct.new(:values, :rcardinality)

        def initialize(item)
          @doc = item
        end

        def item_body
          @item_body ||= begin
            node = @doc.dup
            presentation = node.at_xpath('./presentation')
            prompt = presentation.at_xpath('//material/mattext').content
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
          @scoring_data_structs ||=
            if ordering?
              scoring_data_structs_for_ordering
            else
              default_scoring_data_structs
            end
        end

        private

        def default_scoring_data_structs
          choice_nodes = doc.xpath('.//respcondition')
          choice_nodes.select { |choice_node| choice_node.at_xpath('.//setvar').content.to_f.positive? }
                      .map { |value_node| ScoringData.new(value_node.at_xpath('.//varequal').content, rcardinality) }
        end

        def scoring_data_structs_for_ordering
          @doc.xpath('//conditionvar/varequal').map do |value_node|
            ScoringData.new(value_node.content, rcardinality)
          end
        end

        def ordering?
          rcardinality == 'Ordered'
        end
      end
    end
  end
end
