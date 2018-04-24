require 'qti/v1/models/base'

module Qti
  module V1
    module Models
      class Assessment < Qti::V1::Models::Base
        def title
          @title ||= xpath_with_single_check('.//xmlns:assessment/@title')&.content || File.basename(@path, '.xml')
        end

        def assessment_items
          @doc.xpath('.//xmlns:item')
        end

        def create_assessment_item(assessment_item)
          return nil if stimulus?(assessment_item)
          item = Qti::V1::Models::AssessmentItem.new(assessment_item, @package_root)
          item.manifest = manifest
          item
        end

        def stimulus_ref(assessment_item_ref)
          assessment_item_ref
        end

        def create_stimulus(stimulus_ref)
          return nil unless stimulus?(stimulus_ref)
          Qti::V1::Models::StimulusItem.new(stimulus_ref)
        end

        private

        def stimulus?(ref_node)
          meta_node = ref_node.at_xpath(
            './/xmlns:qtimetadatafield[./xmlns:fieldlabel/text()="question_type"]'
          )
          return false unless meta_node.present?
          type_node = meta_node.at_xpath('.//xmlns:fieldentry')
          type_node&.text() == 'text_only_question'
        end
      end
    end
  end
end
