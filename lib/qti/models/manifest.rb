module Qti
  module Models
    class Manifest < Qti::Models::Base
      include Qti::Models::ResourceGroup
      include Qti::XPathHelpers

      def assessment_test(resource_id = nil)
        resource_id ||= assessment_identifiers.first
        test = assessment_from_identifier(resource_id)
        test.manifest = self
        test
      end

      private

      def assessment_from_identifier(identifier)
        return embedded_non_assessment if identifier == EMBEDDED_NON_ASSESSMENT_ID
        rsc_ver = xpath_with_single_check(xpath_resource("[@identifier='#{identifier}']"))&.[](:type)
        raise_unsupported unless rsc_ver
        assessment_from(rsc_ver, identifier)
      end

      def assessment_from(version, identifier)
        builder = ASSESSMENT_CLASSES[version.split('/').first]
        raise_unsupported unless builder
        rsc = resource_for(identifier, version)
        assessment = builder.from_path!(remap_href_path(asset_resource_for(rsc)), package_root: @package_root,
                                                                                  resource: rsc)
        assessment.canvas_meta_data(rsc.canvas_metadata)
        assessment
      end

      def xmlns_resource(type)
        xpath_with_single_check(xpath_resource(type))
      end

      def xmlns_resource_list(type)
        @doc.xpath(xpath_resource(type))
      end

      def xmlns_resource_count(type)
        xmlns_resource_list(type).count
      end

      def embedded_non_assessment?
        EMBEDDED_QTI_TYPES.map { |typ| xmlns_resource_count("[@type='#{typ}']/@href") }.flatten.sum.positive?
      end

      def embedded_non_assessment
        Qti::V2::Models::NonAssessmentTest.from_path!(@path, package_root: @package_root)
      end
    end
  end
end
