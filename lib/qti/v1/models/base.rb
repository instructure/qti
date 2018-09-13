require 'qti/models/base'

module Qti
  module V1
    module Models
      class Base < Qti::Models::Base
        def qti_version
          1
        end

        def return_inner_content!(node)
          return CGI.unescapeHTML(node.inner_html).html_safe if html_node?(node)
          return node.text if text_node?(node)
          node.inner_html
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
