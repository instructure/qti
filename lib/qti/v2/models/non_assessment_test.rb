module Qti
  module V2
    module Models
      class NonAssessmentTest < Qti::V2::Models::AssessmentTest
        include Qti::Models::ResourceGroup

        QTIV2_TITLE_PATHS = [
          "//*[local-name()='title' and namespace-uri()='http://ltsc.ieee.org/xsd/LOM']/*[local-name()='string']/text()"
        ].freeze

        def assessment_items
          # Return the xml files we should be parsing
          @assessment_items ||= begin
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

        def title
          @title ||= begin
            QTIV2_TITLE_PATHS.map do |path|
              xpath_with_single_check(path)&.content
            end.compact.first
          end || super
        end
      end
    end
  end
end
