require 'qti/v1/models/base'

module Qti
  module V1
    module Models
      module Choices
        class LogicalIdentifierChoice < Qti::V1::Models::Base
          def initialize(node)
            @node = node
          end

          def identifier
            @identifier ||= @node.attributes['ident'].value
          end

          def item_body
            @item_body ||= begin
              node = @node.dup
              node.content.strip.gsub(/\s+/, ' ')
            end
          end
        end
      end
    end
  end
end
