require 'nokogiri'
require 'sanitize'

module Qti
  class ParseError < StandardError; end
  class SpecificationViolation < StandardError; end
  class UnsupportedSchema < StandardError; end

  module Models
    class Base
      attr_reader :doc

      ELEMENTS_REMAP = {
        'prompt' => 'div',
        'simpleBlock' => 'div',
        'simpleInline' => 'span',
        'atomicBlock' => 'div',
        'atomicInline' => 'span'
      }.freeze

      def sanitize_content!(html)
        Sanitize.fragment(html, sanitize_config)
      end

      def remap_unknown_tags_transformer
        lambda do |env|
          node_name = env[:node_name]
          node = env[:node]

          return if env[:is_whitelisted] || !node.element?
          return unless ELEMENTS_REMAP.keys.include? node_name

          new_name = ELEMENTS_REMAP[node_name]
          env[:node].name = new_name
          env[:node_name] = new_name
        end
      end

      def sanitize_config
        Sanitize::Config::RELAXED.merge transformers: remap_unknown_tags_transformer
      end

      def self.from_path!(path)
        new(path: path)
      end

      def initialize(path: nil)
        @path = path
        @doc = parse_xml(File.read(path))
        raise ArgumentError unless @doc
      end

      def xpath_with_single_check(xpath)
        node_list = @doc.xpath(xpath)
        raise Qti::ParseError, 'Too many matches' if node_list.count > 1
        node_list.first
      end

      def css_with_single_check(css)
        node_list = @doc.css(css)
        raise Qti::ParseError, 'Too many matches' if node_list.count > 1
        node_list.first
      end

      def parse_xml(xml_string)
        Nokogiri.XML(xml_string, &:noblanks)
      end

      def remap_href_path(href, source_path)
        return href unless href
        # Attempts to map to a file path relative href if href doesn't exist
        # Returns original href if that file doesn't exist
        if File.exist?(href)
          href
        else
          new_path = File.join(File.dirname(source_path), href)
          File.exist?(new_path) ? new_path : href
        end
      end
    end
  end
end
