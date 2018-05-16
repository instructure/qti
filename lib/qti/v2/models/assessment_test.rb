require 'qti/v2/models/base'
require 'qti/models/assessment_meta'

module Qti
  module V2
    module Models
      class AssessmentTest < Qti::V2::Models::Base
        include Qti::Models::AssessmentMetaBase
        def title
          @title ||= xpath_with_single_check('//xmlns:assessmentTest/@title')&.content || File.basename(@path, '.xml')
        end

        def assessment_items
          # Return the xml files we should be parsing
          @assessment_item_reference_hrefs ||= begin
            @doc.xpath('//xmlns:assessmentItemRef/@href').map(&:content).map do |href|
              remap_href_path(href)
            end
          end
        end

        def test_parts
          @test_parts ||= @doc.xpath('//xmlns:testPart')
        end

        def assessment_sections
          @assessment_sections ||= test_parts.first.xpath('//xmlns:assessmentSection')
        end

        def create_assessment_item(assessment_item_ref)
          item = Qti::V2::Models::AssessmentItem.from_path!(assessment_item_ref, @package_root)
          item.manifest = manifest
          item
        end

        def stimulus_ref(_ref)
          nil
        end

        def create_stimulus(stimulus_ref)
          Qti::V2::Models::StimulusItem.new(path: stimulus_ref, package_root: @package_root, html: true)
        end
      end
    end
  end
end
