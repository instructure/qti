module Qti
  module V1
    module Models
      module Interactions
        class UploadInteraction < BaseInteraction
          # This will know if a class matches
          def self.matches(node, parent)
            meta_node = node.at_xpath(
              './/xmlns:qtimetadatafield[./xmlns:fieldlabel/text()="question_type"]'
            )
            return false unless meta_node.present?
            type_node = meta_node.at_xpath('.//xmlns:fieldentry')
            return false unless type_node&.text() == 'file_upload_question'
            new(node, parent)
          end

          def item_body
            @item_body ||= begin
              node = @node.dup
              presentation = node.at_xpath('.//xmlns:presentation')
              mattext = presentation.at_xpath('.//xmlns:mattext')
              inner_content = return_inner_content!(mattext)
              sanitize_content!(inner_content)
            end
          end

          def scoring_data_structs
            { value: '' }
          end

          def allowed_types
            @allowed_types ||= @node.at_xpath('.//xmlns:presentation/@allowed_types')&.value
          end

          def files_count
            @files_count ||= @node.at_xpath('.//xmlns:presentation/@files_count')&.value
          end
        end
      end
    end
  end
end
