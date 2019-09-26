module Qti
  module V1
    module Models
      class QuestionGroup < Qti::V1::Models::Base
        attr_reader :doc

        def initialize(item, package_root = nil)
          @doc = item
          @path = item.document.url
          self.package_root = package_root
        end

        def test_object
          self
        end

        def assessment_item_refs
          items
        end

        def create_assessment_item(assessment_item)
          Qti::V1::Models::AssessmentItem.new(assessment_item)
        end

        def items
          @doc.xpath('.//xmlns:item')
        end

        def selection
          @doc.xpath('xmlns:selection_ordering/xmlns:selection')
        end

        def selection_number
          selection&.xpath('xmlns:selection_number')&.text&.to_i
        end

        def points_per_item
          selection.xpath('xmlns:selection_extension/xmlns:points_per_item')&.text&.to_f
        end

        def identifier
          @identifier ||= @doc.attribute('ident').value
        end

        def title
          @title ||= @doc.attribute('title').value
        end

        def group_item?(item)
          item.xpath('../section').first&.dig('ident') == ident
        end
      end
    end
  end
end
