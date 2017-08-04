require 'nokogiri'
require 'sanitize'
require 'pathname'

module Qti
  class ParseError < StandardError; end
  class SpecificationViolation < StandardError; end
  class UnsupportedSchema < StandardError; end

  module Models
    class Base
      attr_reader :doc, :path, :package_root

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

      def self.from_path!(path, package_root = nil)
        new(path: path, package_root: package_root)
      end

      def initialize(path:, package_root: nil)
        @path = path
        set_package_root(package_root || File.dirname(path))
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
        Nokogiri.XML(xml_string, @path.to_s, &:noblanks)
      end

      def remap_href_path(href)
        return nil unless href
        path = File.join(File.dirname(@path), href)
        if @package_root.nil?
          raise Qti::ParseError, "Potentially unsafe href '#{href}'" if href.split('/').include?('..')
        else
          raise Qti::ParseError, "Unsafe href '#{href}'" unless Pathname.new(path).cleanpath.to_s.start_with?(@package_root)
        end
        path
      end

      protected

      def set_package_root(package_root)
        @package_root = package_root
        return unless @package_root
        @package_root = Pathname.new(@package_root).cleanpath.to_s + '/'
      end
    end
  end
end
