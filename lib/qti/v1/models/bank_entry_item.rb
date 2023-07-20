module Qti
  module V1
    module Models
      class BankEntryItem < Qti::V1::Models::Base
        attr_reader :doc

        def initialize(item, package_root = nil)
          @doc = item
          @path = item.document.url
          self.package_root = package_root
        end

        def sourcebank_ref
          @sourcebank_ref ||= @doc.attribute('sourcebank_ref').value
        end

        def item_ref
          @item_ref ||= @doc.attribute('item_ref').value
        end

        def points_possible
          @points_possible ||= @doc.attribute('points_possible')&.value || 1
        end
      end
    end
  end
end
