require 'qti/models/base'

module Qti
  module V1
    module Models
      class Base < Qti::Models::Base
        def qti_version
          1
        end

        def return_inner_content!(node)
          if node.attributes['texttype']&.value == 'text/plain' ||
             node.child.cdata? || node.inner_html.include?('&gt' || '&lt')
            node.text
          else
            node.inner_html
          end
        end
      end
    end
  end
end
