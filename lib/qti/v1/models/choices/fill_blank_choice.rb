require 'qti/v1/models/base'

module Qti
  module V1
    module Models
      module Choices
        class FillBlankChoice < Qti::V1::Models::Base
          def initialize(node, parent)
            @node = node
            copy_paths_from_item(parent)
          end

          def identifier
            @identifier ||= @node.attributes['respident']&.value ||
                            @node.attributes['ident']&.value
          end

          def item_body
            @item_body ||= begin
              node = @node.dup
              inner_content = return_inner_content!(node)
              sanitize_content!(inner_content)
            end
          end
        end
      end
    end
  end
end
