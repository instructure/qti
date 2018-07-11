require 'nokogiri'
require 'sanitize'
require 'uri'

module Qti
  class Sanitizer
    ELEMENTS_REMAP = {
      'prompt' => 'div',
      'simpleBlock' => 'div',
      'simpleInline' => 'span',
      'atomicBlock' => 'div',
      'atomicInline' => 'span'
    }.freeze

    PROTOCOLS = ['http', 'https', :relative].freeze
    FILTER_TAGS = %w[iframe object embed].freeze

    CONFIG =
      {
        elements: FILTER_TAGS,
        protocols:
          {
            'iframe' => { 'src' => PROTOCOLS },
            'object' => { 'src' => PROTOCOLS },
            'embed' => { 'src' => PROTOCOLS }
          }.freeze,
        attributes:
          {
            'object' => %w[src width height style data type classid codebase],
            'embed' => %w[name src type allowfullscreen pluginspage wmode
                          allowscriptaccess width height],
            'iframe' => %w[src width height name align frameborder scrolling sandbox
                           allowfullscreen webkitallowfullscreen mozallowfullscreen
                           allow] # TODO: remove explicit allow with domain whitelist account setting
          }.freeze
      }.freeze

    def clean(html)
      Sanitize.fragment(html, sanitize_config)
    end

    private

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

    def src_transformers
      lambda do |env|
        return unless FILTER_TAGS.include?(env[:node_name])
        return if env[:is_whitelisted] || !env[:node].element?
        Sanitize.node!(env[:node], CONFIG)
        { node_whitelist: [env[:node]] }
      end
    end

    def sanitize_config(import_objects: true)
      transformers = []
      transformers << src_transformers
      transformers << object_tag_transformer if import_objects
      transformers << remap_unknown_tags_transformer
      Sanitize::Config::RELAXED.merge transformers: transformers
    end

    def remap_href_path(href)
      return nil unless href
      path = File.join(File.dirname(@path), href)
      if @package_root.nil?
        raise Qti::ParseError, "Potentially unsafe href '#{href}'" if href.split('/').include?('..')
      else
        unless Pathname.new(path).cleanpath.to_s.start_with?(@package_root)
          raise Qti::ParseError, "Unsafe href '#{href}'"
        end
      end
      path
    end

    def replace_object_node(node)
      path = remap_href_path(node[:data])
      if path
        case node[:type]
        when %r{^image\/}
          return replace_with_image(node, node[:data])
        when 'text/html'
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
