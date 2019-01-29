module Qti
  module V1
    module Models
      class StimulusItem < Qti::V1::Models::Base
        def initialize(ref_node)
          @node = ref_node
        end

        def identifier
          @identifier ||= @node.attributes['ident']&.value
        end

        def title
          @title ||= @node.attributes['title']&.value
        end

        def body
          @body ||= begin
            presentation = @node.at_xpath('.//xmlns:presentation')
            return nil if presentation.blank?
            sanitize_content!(presentation.at_xpath('.//xmlns:mattext')&.text)
          end
        end

        def stimulus_type
          'text'
        end
      end
    end
  end
end
