require 'qti/v1/models/base'
require 'qti/models/assessment_meta'
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
        assessment_from(rsc_ver, identifier)
      end

      def assessment_from(version, identifier)
        builder = ASSESSMENT_CLASSES[version.split('/').first]
        raise_unsupported unless builder
        canvas_meta = canvas_meta_data_for(identifier)
        assessment = builder.from_path!(
          remap_href_path(asset_resource_for(identifier, version, canvas_meta&.quiz_identifier)),
          @package_root
        )
        assessment.canvas_meta_data(canvas_meta_data_for(identifier))
        assessment
      end

      def asset_resource_for(identifier, qti_type, canvas_ident)
        asset_resource_for_canvas(canvas_ident) || asset_resource_for_ims(identifier, qti_type)
      end

      def asset_resource_for_canvas(identifier)
        canvas_extra_file(identifier, '.xml.qti')
      end

      def asset_resource_for_ims(identifier, qti_type)
        base_xpath = "[@identifier='#{identifier}' and starts-with(@type, '#{qti_type}')]"
        xmlns_resource(base_xpath + '/@href') || xmlns_resource(base_xpath + '/xmlns:file/@href')
      end

      def dependency_id(identifier)
        xmlns_resource("[@identifier='#{identifier}']/xmlns:dependency/@identifierref")
      end

      def canvas_meta_data_for(identifier)
        meta_file = canvas_extra_file(identifier, 'assessment_meta.xml')
        return Qti::Models::AssessmentMeta.from_path!(File.join(@package_root, meta_file)) if meta_file
      end

      def canvas_extra_file(identifier, filename)
        dep_id = dependency_id(identifier)
        xmlns_resource(
          "[@identifier='#{dep_id}']/xmlns:file[#{xpath_endswith('@href', filename)}]/@href"
        )
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

      def xpath_endswith(tag, tail)
        "substring(#{tag}, string-length(#{tag}) - string-length('#{tail}') + 1) = '#{tail}'"
      end

      def rtype_predicate(ver, rsc_type)
        # XPath 2.0 supports ends-with, which is what substring is doing here.
        # It also support regex matching with matches.
        # We only have XPath 1.0 available.
        cc_match = "starts-with(@type, '#{ver}') and " + xpath_endswith('@type', rsc_type)
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
