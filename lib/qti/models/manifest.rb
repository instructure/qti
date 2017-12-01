require 'qti/v1/models/base'

module Qti
  module Models
    class Manifest < Qti::Models::Base
      def assessment_test
        test = qti_2_x_href || qti_1_href || qti_2_non_assessment_href || unknown_type
        test.manifest = self
        test
      end

      def qti_1_href
        test_path = xmlns_resource("[@type='imsqti_xmlv1p2']/@href") ||
                    xmlns_resource("[@type='imsqti_xmlv1p2']/xmlns:file/@href")
        return unless test_path
        Qti::V1::Models::Assessment.from_path!(
          remap_href_path(test_path), @package_root
        )
      end

      def qti_2_x_href
        test_path = xmlns_resource("[@type='imsqti_test_xmlv2p1']/@href") ||
                    xmlns_resource("[@type='imsqti_test_xmlv2p2']/@href")
        return unless test_path
        Qti::V2::Models::AssessmentTest.from_path!(
          remap_href_path(test_path), @package_root
        )
      end

      def qti_2_non_assessment_href
        item_path = @doc.at_xpath("//xmlns:resources/xmlns:resource[@type='imsqti_item_xmlv2p1']/@href")&.content ||
                    @doc.at_xpath("//xmlns:resources/xmlns:resource[@type='imsqti_item_xmlv2p2']/@href")
        Qti::V2::Models::NonAssessmentTest.from_path!(@path, @package_root) if item_path
      end

      def unknown_type
        raise Qti::UnsupportedSchema, 'Unsupported QTI version'
      end

      private

      def xmlns_resource(type)
        xpath_with_single_check("//xmlns:resources/xmlns:resource#{type}")&.content
      end
    end
  end
end
