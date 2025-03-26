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

        def instructions
          @instructions ||= @node.attributes['instructions']&.value
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

        def qti_metadata_children
          @node.at_xpath('.//xmlns:qtimetadata')&.children
        end

        def source_url_qti_metadata?
          if @node.at_xpath('.//xmlns:qtimetadata').present?
            source_url_label = qti_metadata_children.children.find { |node| node.text == 'source_url' }
            source_url_label.present?
          else
            false
          end
        end

        def source_url
          @source_url ||= begin
            if source_url_qti_metadata?
              source_url_label = qti_metadata_children.children.find do |node|
                node.text == 'source_url'
              end
              source_url_label&.next&.text
            end
          end
        end

        def default_orientation
          passage == 'true' ? 'top' : 'left'
        end

        def orientation
          @orientation ||= begin
            presentation = @node.at_xpath('.//xmlns:presentation')
            return default_orientation if presentation.blank?

            orientation_value = presentation.at_xpath('.//xmlns:material')&.attributes&.[]('orientation')&.value
            orientation_value.presence || default_orientation
          end
        end

        def passage_qti_metadata?
          qti_metadata_children.children.any? { |node| node.text == 'passage' }
        end

        def passage
          return false unless passage_qti_metadata?

          passage_label = qti_metadata_children.children.find { |node| node.text == 'passage' }
          passage_label&.next&.text.presence || false
        end
      end
    end
  end
end
