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
              inner_content = return_inner_content!(content_node)
              sanitize_content!(inner_content)
            end
          end

          private

          # @node is answer node queried in callers by:
          #   node.xpath('.//xmlns:response_label')
          # inner content should be in child node (mattext ...)
          # `texttype` is an attribute of mattext element.
          # Possible child node types of response_label include:
          #   mattext, matmtext, matimage, mataudio ... ...
          # from the code context, obviously we don't cover the full
          # specification. We only consider mattext here.
          # If there is no mattext, we basically go through original
          # logic
          def content_node
            (@node.at_xpath('.//xmlns:mattext') || @node).dup
          end
        end
      end
    end
  end
end
