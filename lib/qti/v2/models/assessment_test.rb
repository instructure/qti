require 'qti/v2/models/base'

module Qti
  module V2
    module Models
      class AssessmentTest < Qti::V2::Models::Base
        def title
          @title ||= xpath_with_single_check('//xmlns:assessmentTest/@title')&.content || File.basename(@path, ".xml")
        end

        def assessment_item_reference_hrefs
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
      end
    end
  end
end
