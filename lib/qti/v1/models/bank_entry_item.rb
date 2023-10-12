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

        def parent_stimulus_item_ident
          @parent_stimulus_item_ident ||= @doc.attribute('parent_stimulus_item_ident')&.value
        end

        def points_possible
          @points_possible ||= @doc.attribute('points_possible')&.value || 1
        end

        def entry_type
          @entry_type ||= @doc.attribute('entry_type')&.value
        end
      end
    end
  end
end
