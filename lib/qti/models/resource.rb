module Qti
  module Models
    class Resource < Qti::Models::Base
      include Qti::XPathHelpers

      delegate :taxonpath, to: :@metadata, allow_nil: true

      def initialize(node, parent)
        @node = node
        @parent = parent
        @resource_type = node.attr('type')
        @identifier = node.attr('identifier')
        copy_paths_from_item(parent)
      end

      def href
        @href ||= @node.attr('href') || @node.xpath('xmlns:file/@href')&.first&.content
      end

      def metadata
        @metadata ||= MetaData.new(@node)
      end

      def canvas_metadata
        @canvas_meta_file ||= canvas_extra_file('assessment_meta.xml')
        return unless @canvas_meta_file
        meta_file = File.join(@package_root, @canvas_meta_file)
        @canvas_metadata ||= Qti::Models::AssessmentMeta.from_path!(meta_file) if @canvas_meta_file
      end

      def canvas_extra_file(filename)
        dep_id = dependency_id
        rsc = @parent.resource_node(
          "[@identifier='#{dep_id}']/xmlns:file[#{xpath_endswith('@href', filename)}]/@href"
        )
        rsc&.content
      end

      private

      # Canvas Metadata Helpers
      def dependency_id
        @node.xpath('xmlns:dependency/@identifierref')&.first&.content
      end
    end

    module ResourceGroup
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

      def resources(type = '')
        @doc.xpath(xpath_resource(type))
      end

      def asset_resource_for(rsc)
        asset_resource_for_canvas(rsc) || asset_resource_for_ims(rsc)
      end

      def asset_resource_for_canvas(rsc)
        rsc.canvas_extra_file('.xml.qti')
      end

      def asset_resource_for_ims(rsc)
        rsc.href
      end

      def identifier_list(rsc_type)
        RESOURCE_QTI_TYPES.map do |v|
          xmlns_resource_list("[#{rtype_predicate(v, rsc_type)}]").map { |r| r[:identifier] }
        end.flatten
      end

      def resource_for(identifier, qti_type = nil)
        qti_type = " and starts-with(@type, '#{qti_type}')" if qti_type
        base_xpath = "[@identifier='#{identifier}'#{qti_type}]"
        Resource.new(resource_node(base_xpath), self)
      end

      def assessment_identifiers(embedded_as_assessment = true)
        id_list = identifier_list('/assessment')
        return id_list + [EMBEDDED_NON_ASSESSMENT_ID] if embedded_as_assessment && embedded_non_assessment?
        id_list
      end

      def question_bank_identifiers
        identifier_list('/question-bank')
      end

      def item_resources_v2
        nodes = resources('[@type="imsqti_item_xmlv2p2"]')
        return nodes if nodes.count >= 1
        resources('[@type="imsqti_item_xmlv2p1"]')
      end

      def resource_node(type)
        xpath_with_single_check(xpath_resource(type))
      end
    end
  end
end
