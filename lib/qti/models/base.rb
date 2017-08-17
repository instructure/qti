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

      def object_tag_transformer
        lambda do |env|
          return unless env[:node_name] == 'object'
          return if env[:is_whitelisted] || !env[:node].element?
          replace_object_node(env[:node])
        end
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

      def sanitize_config(import_objects: true)
        transformers = []
        transformers << object_tag_transformer if import_objects
        transformers << remap_unknown_tags_transformer
        Sanitize::Config::RELAXED.merge transformers: transformers
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

      def set_paths_from_item(other_item)
        @package_root = other_item.package_root
        @path = other_item.path
      end

      def replace_object_node(node)
        path = remap_href_path(node[:data])
        if path
          case node[:type]
          when /^image\//
            return replace_with_image(node, node[:data])
          when "text/html"
            return replace_with_html(node, path)
          end
        end
        # remove unrecognized or invalid objects from the sanitized document
        node.unlink
      end

      def replace_with_image(node, src)
        node.name = 'img'
        node[:src] = src
      end

      def replace_with_html(node, path)
        begin
          content = File.read(path)
          html_content = Sanitize.fragment(content, sanitize_config(import_objects: false))
          node.name = 'div'
          node.add_child(Nokogiri::HTML.fragment(html_content))
        rescue StandardError => e
          warn "failed to import html object #{path}: #{e.message}"
          node.unlink
        end
      end
    end
  end
end
