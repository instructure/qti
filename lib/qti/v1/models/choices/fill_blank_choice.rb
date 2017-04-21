require 'qti/v1/models/base'

module Qti
  module V1
    module Models
      module Choices
        class FillBlankChoice < Qti::V1::Models::Base
          def initialize(node)
            @node = node
          end

          def identifier
            @identifier ||= @node.attributes['respident']&.value ||
              @node.attributes['ident']&.value
          end

          def item_body
            @item_body ||= begin
              node = @node.dup
              node.content.squish
            end
          end
        end
      end
    end
  end
end
