require 'qti/v1/models/base'
require 'qti/v1/models/assessment'
require 'qti/v2/models/assessment_test'
require 'qti/v2/models/non_assessment_test'

module Qti
  module Models
    class Manifest < Qti::Models::Base
      RESOURCE_QTI_TYPES = %w[imsqti_test_xmlv2p1
                              imsqti_test_xmlv2p2
                              imsqti_xmlv1p2].freeze
      ASSESSMENT_CLASSES = {
        'imsqti_xmlv1p2' => Qti::V1::Models::Assessment,
        'imsqti_test_xmlv2p1' => Qti::V2::Models::AssessmentTest,
        'imsqti_test_xmlv2p2' => Qti::V2::Models::AssessmentTest
      }.freeze
      EMBEDDED_QTI_TYPES = %w[imsqti_item_xmlv2p1
                              imsqti_item_xmlv2p2].freeze
      EMBEDDED_NON_ASSESSMENT_ID = '@embedded_non_assessment'.freeze

      def assessment_test(resource_id = nil)
        resource_id ||= assessment_identifiers.first
        test = assessment_from_identifier(resource_id)
        test.manifest = self
        test
      end

      def raise_unsupported
        raise Qti::UnsupportedSchema, 'Unsupported QTI version'
      end

      def assessment_identifiers(embedded_as_assessment = true)
        id_list = identifier_list('/assessment')
        return id_list + [EMBEDDED_NON_ASSESSMENT_ID] if embedded_as_assessment && embedded_non_assessment?
        id_list
      end

      def question_bank_identifiers
        identifier_list('/question-bank')
      end

      def identifier_list(rsc_type)
        RESOURCE_QTI_TYPES.map do |v|
          xmlns_resource_list("[#{rtype_predicate(v, rsc_type)}]").map { |r| r[:identifier] }
        end.flatten
      end

      private

      def assessment_from_identifier(identifier)
        return embedded_non_assessment if identifier == EMBEDDED_NON_ASSESSMENT_ID
        rsc_ver = xpath_with_single_check(xpath_xmlns_resource("[@identifier='#{identifier}']"))&.[](:type)
        raise_unsupported unless rsc_ver
        builder = assessment_class_from_version(rsc_ver)
        raise_unsupported unless builder
        builder.from_path!(remap_href_path(asset_resource_for(identifier, rsc_ver)), @package_root)
      end

      def assessment_class_from_version(version)
        ASSESSMENT_CLASSES[version.split('/').first]
      end

      def asset_resource_for(identifier, qti_type)
        base_xpath = "[@identifier='#{identifier}' and starts-with(@type, '#{qti_type}')]"
        xmlns_resource(base_xpath + '/@href') || xmlns_resource(base_xpath + '/xmlns:file/@href')
      end

      def xmlns_resource(type)
        xpath_with_single_check(xpath_xmlns_resource(type))&.content
      end

      def xmlns_resource_list(type)
        @doc.xpath(xpath_xmlns_resource(type))
      end

      def xmlns_resource_count(type)
        xmlns_resource_list(type).count
      end

      def xpath_xmlns_resource(type = '')
        "//xmlns:resources/xmlns:resource#{type}"
      end

      def rtype_predicate(ver, rsc_type)
        # XPath 2.0 supports ends-with, which is what substring is doing here.
        # It also support regex matching with matches.
        # We only have XPath 1.0 available.
        cc_match = "starts-with(@type, '#{ver}') and " \
          "substring(@type, string-length(@type) - string-length('#{rsc_type}') + 1) = '#{rsc_type}'"
        qti_match = "@type='#{ver}'"
        "#{qti_match} or (#{cc_match})"
      end

      def embedded_non_assessment?
        EMBEDDED_QTI_TYPES.map { |typ| xmlns_resource_count("[@type='#{typ}']/@href") }.flatten.sum.positive?
      end

      def embedded_non_assessment
        Qti::V2::Models::NonAssessmentTest.from_path!(@path, @package_root)
      end
    end
  end
end
