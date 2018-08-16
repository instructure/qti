module Qti
  module V1
    module Models
      class StimulusItem
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
            mattext = presentation.at_xpath('.//xmlns:mattext')
            mattext&.text
          end
        end

        def stimulus_type
          'text'
        end
      end
    end
  end
end
