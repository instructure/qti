module Qti
  module V2
    module Models
      class AssessmentTest < Qti::V2::Models::Base
        include Qti::Models::AssessmentMetaBase
        include Qti::XPathHelpers

        def identifier
          @identifier ||= xpath_with_single_check('//xmlns:assessmentTest/@identifier')&.content
        end

        def title
          @title ||= xpath_with_single_check('//xmlns:assessmentTest/@title')&.content || File.basename(@path, '.xml')
        end

        def external_assignment_id
          nil
        end

        def assessment_items
          # Return the xml files we should be parsing
          @assessment_items ||= begin
            @doc.xpath('//xmlns:assessmentItemRef/@href').map(&:content).map do |href|
              { path: remap_href_path(href), resource: self }
            end
          end
        end

        def test_parts
          @test_parts ||= @doc.xpath('//xmlns:testPart')
        end

        def assessment_sections
          @assessment_sections ||= test_parts.first.xpath('//xmlns:assessmentSection')
        end

        def create_assessment_item(ref)
          item = Qti::V2::Models::AssessmentItem.from_path!(ref[:path], package_root: @package_root,
                                                                        resource: ref[:resource])
          item.manifest = manifest
          item
        end

        def stimulus_ref(_ref)
          nil
        end

        def create_stimulus(stimulus_ref)
          Qti::V2::Models::StimulusItem.new(path: stimulus_ref, package_root: @package_root, html: true)
        end

        def create_bank_entry_item(_bank_entry_item_ref = nil)
          nil # we don't support this in QTI V2 yet
        end
      end
    end
  end
end
