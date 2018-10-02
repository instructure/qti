module Qti
  module Models
    class MetaData < Qti::Models::Base
      def initialize(node)
        @node = node
      end

      def taxonpaths
        return unless lom
        hier = Hash.new { |h, k| h[k] = [] }
        lom.xpath('imsmd:classification/imsmd:taxonPath').each do |tp|
          entry = taxonpath_entry(tp)
          hier[entry[:source]] = entry[:taxonpath]
        end
        hier
      end

      private

      def taxonpath_entry(node)
        {
          source: node.xpath('imsmd:source/imsmd:string').text,
          taxonpath: taxons(node)
        }
      end

      def metadata
        @metadata ||= @node&.xpath('xmlns:metadata')&.first
      end

      def lom
        return unless imsmd
        @lom ||= metadata&.xpath('imsmd:lom')&.first
      end

      def imsmd
        @node.namespaces&.keys&.include?('xmlns:imsmd')
      end

      def taxons(node)
        hier = Hash.new { |h, k| h[k] = [] }
        taxon(node, hier)
      end

      def taxon(node, path)
        return path unless node
        xpath = 'imsmd:taxon/imsmd:entry/*[self::imsmd:string or self::imsmd:langstring]'
        node.xpath(xpath).each do |taxon|
          lang = taxon.attr('language') || taxon.attr('lang') || taxon.attr('xml:lang') || 'default'
          path[lang].push(taxon.text)
        end
        taxon(node.xpath('imsmd:taxon')&.first, path)
      end
    end

    module MetaDataBase
      delegate :taxonpath, to: :@meta_data, allow_nil: true
      def metadata_from_node!(node)
        @meta_data ||= MetaData.new(node)
      end
    end
  end
end
