require 'qti/v1/models/base'

module Qti
  module V1
    module Models
      module Choices
        class LogicalIdentifierChoice < Qti::V1::Models::Base
          def initialize(node, parent)
            @node = node
            copy_paths_from_item(parent)
          end

          def identifier
            @identifier ||= @node.attributes['ident'].value
          end

          def item_body
            @item_body ||= begin
              node = @node.dup
              sanitize_content!(node.to_html)
            end
          end
        end
      end
    end
  end
end
