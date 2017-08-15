module Qti
  module V2
    module Models
      class StimulusItem < Qti::V2::Models::Base

        def body
          @body ||= begin
            item_body_node = xpath_with_single_check('//html/body')
            node = item_body_node.dup

            # Filter undesired interaction nodes out of the list (need to make this a deep traversal)
            node.children.filter(INTERACTION_ELEMENTS_CSS).map(&:unlink)
            sanitize_content!(node.to_html)
          end
        end

        # Not used yet
        def identifier
          @identifier ||= File.basename(path, '.html')
        end

        def title
          @title ||= xpath_with_single_check('//html/head/title')&.content
        end

        def stimulus_type
          'text'
        end
      end
    end
  end
end
