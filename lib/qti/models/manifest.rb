require 'qti/v1/models/base'

module Qti
  module Models
    class Manifest < Qti::Models::Base
      def assessment_test_href
        href = qti_1_href.nil? ? qti_2_x_href : qti_1_href
        remap_href_path(href, @path)
      end

      def qti_1_href
        xpath_with_single_check("//xmlns:resources/xmlns:resource[@type='imsqti_xmlv1p2']/@href")&.content ||
          xpath_with_single_check("//xmlns:resources/xmlns:resource[@type='imsqti_xmlv1p2']/xmlns:file/@href")&.content
      end

      def qti_2_x_href
        xpath_with_single_check("//xmlns:resources/xmlns:resource[@type='imsqti_test_xmlv2p1']/@href")&.content ||
          xpath_with_single_check("//xmlns:resources/xmlns:resource[@type='imsqti_test_xmlv2p2']/@href")&.content
      end
    end
  end
end
