require 'qti/v2/models/base'

module Qti
  module V2
    module Models
      class NonAssessmentTest < Qti::V2::Models::AssessmentTest
        def assessment_items
          # Return the xml files we should be parsing
          @assessment_item_reference_hrefs ||= begin
            @doc.xpath("//xmlns:resource[@type='imsqti_item_xmlv2p1']/@href").map(&:content).map do |href|
              remap_href_path(href)
            end
          end
        end
      end
    end
  end
end