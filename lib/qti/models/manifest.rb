require 'qti/v1/models/base'

module Qti
  module Models
    class Manifest < Qti::Models::Base
      def assessment_test
        qti_2_x_href || qti_1_href || qti_2_non_assessment_href || unknown_type
      end

      def qti_1_href
        test_path = xpath_with_single_check("//xmlns:resources/xmlns:resource[@type='imsqti_xmlv1p2']/@href")&.content ||
                    xpath_with_single_check("//xmlns:resources/xmlns:resource[@type='imsqti_xmlv1p2']/xmlns:file/@href")&.content
        Qti::V1::Models::Assessment.from_path!(remap_href_path(test_path), @package_root) if test_path
      end

      def qti_2_x_href
        test_path = xpath_with_single_check("//xmlns:resources/xmlns:resource[@type='imsqti_test_xmlv2p1']/@href")&.content ||
                    xpath_with_single_check("//xmlns:resources/xmlns:resource[@type='imsqti_test_xmlv2p2']/@href")&.content
        Qti::V2::Models::AssessmentTest.from_path!(remap_href_path(test_path), @package_root) if test_path
      end

      def qti_2_non_assessment_href
        item_path = @doc.at_xpath("//xmlns:resources/xmlns:resource[@type='imsqti_item_xmlv2p1']/@href")&.content
        Qti::V2::Models::NonAssessmentTest.from_path!(@path, @package_root) if item_path
      end

      def unknown_type
        raise Qti::UnsupportedSchema, 'Unsupported QTI version'
      end
    end
  end
end
