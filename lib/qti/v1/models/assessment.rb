require 'qti/v1/models/base'
require 'qti/models/assessment_meta'

module Qti
  module V1
    module Models
      class Assessment < Qti::V1::Models::Base
        include Qti::Models::AssessmentMetaBase
        GROUP_ID = 'xmlns:section/xmlns:selection_ordering'.freeze

        def title
          @title ||= xpath_with_single_check('.//xmlns:assessment/@title')&.content || File.basename(@path, '.xml')
        end

        def assessment_items
          @doc.xpath("//*[self::#{GROUP_ID} or self::xmlns:item[not(ancestor::#{GROUP_ID})]]")
        end

        def create_assessment_item(assessment_item)
          return nil if sub_section?(assessment_item)
          item = Qti::V1::Models::AssessmentItem.new(assessment_item, @package_root, self)
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

        def create_question_group(group_ref)
          return nil unless question_group?(group_ref)
          Qti::V1::Models::QuestionGroup.new(group_ref)
        end

        private

        def sub_section?(ref_node)
          stimulus?(ref_node) || question_group?(ref_node)
        end

        def stimulus?(ref_node)
          meta_node = ref_node.at_xpath(
            './/xmlns:qtimetadatafield[./xmlns:fieldlabel/text()="question_type"]'
          )
          return false unless meta_node.present?
          type_node = meta_node.at_xpath('.//xmlns:fieldentry')
          type_node&.text() == 'text_only_question'
        end

        def question_group?(ref_node)
          ref_node.xpath("self::#{GROUP_ID}").present?
        end
      end
    end
  end
end
