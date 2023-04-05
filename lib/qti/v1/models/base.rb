module Qti
  module V1
    module Models
      class Base < Qti::Models::Base
        CANVAS_BLANK_REGEX ||= /(\[[A-Za-z0-9_\-.]+\])/.freeze

        def qti_version
          1
        end

        def return_inner_content!(node)
          return CGI.unescapeHTML(node.inner_html).html_safe if html_node?(node)
          return node.text if text_node?(node)
          node.inner_html
        end

        def sanitize_attributes(html)
          node = Nokogiri::HTML.fragment(html)
          sanitize_attributes_by_node(node)
          node.to_html
        end

        def sanitize_attributes_by_node(node)
          node.attribute_nodes.each do |a|
            matches = a.value.match(CANVAS_BLANK_REGEX) || []
            a.value = a.value.gsub!('[', '&#91;').gsub!(']', '&#93;') if matches.length.positive?
          end
          node.children.each { |c| sanitize_attributes_by_node(c) }
        end

        private

        def text_node?(node)
          node.attributes['texttype']&.value == 'text/plain' ||
            node.child&.cdata? || node.inner_html.include?('&gt' || '&lt')
        end

        def html_node?(node)
          node.attributes['texttype']&.value == 'text/html'
        end
      end
    end
  end
end
