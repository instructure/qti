require 'qti/v1/models/base'

module Qti
  module V1
    module Models
      class Assessment < Qti::V1::Models::Base
        def title
          @title ||= xpath_with_single_check('.//xmlns:assessment/@title')&.content || File.basename(@path, '.xml')
        end

        def assessment_items
          @doc.xpath('.//xmlns:item')
        end
      end
    end
  end
end
