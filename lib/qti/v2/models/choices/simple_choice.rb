require 'qti/v2/models/base'

module Qti
  module V2
    module Models
      module Choices
        class SimpleChoice < Qti::V2::Models::Base
          PROHIBITED_NODE_NAMES = %w(feedbackInline).join(',').freeze
          def initialize(node)
            @node = node
          end

          def identifier
            @identifier ||= @node.attributes['identifier'].value
          end

          def item_body
            @item_body ||= begin
              node = @node.dup
              node.children.filter(PROHIBITED_NODE_NAMES).map(&:unlink)
              node.content.strip.gsub(/\s+/, ' ')
            end
          end
        end
      end
    end
  end
end
