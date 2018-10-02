require 'qti/v2/models/base'
require 'qti/models/resource'

module Qti
  module V2
    module Models
      class NonAssessmentTest < Qti::V2::Models::AssessmentTest
        include Qti::Models::ResourceGroup
        def assessment_items
          # Return the xml files we should be parsing
          @assessment_item_resources ||= begin
            item_resources_v2.map do |node|
              rsc = Qti::Models::Resource.new(node, self)
              { path: remap_href_path(rsc.href), resource: rsc }
            end
          end
        end

        def stimulus_ref(assessment_item_ref)
          ref = assessment_item_ref[:path].sub(@package_root, '')
          dependencies = @doc.xpath("//xmlns:resource[@href='#{ref}']/xmlns:dependency/@identifierref")
          return unless dependencies&.count == 1
          href = xpath_with_single_check("//xmlns:resource[@identifier='#{dependencies.first}']/@href")
          remap_href_path(href)
        end
      end
    end
  end
end
