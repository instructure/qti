require 'qti/v2/models/base'

module Qti
  module V2
    module Models
      module Choices
        class SimpleAssociableChoice < SimpleChoice
          def match_max
            @_match_max ||= @node.attributes['matchMax'].value || 0
          end

          def match_min
            @_match_min ||= @node.attributes['matchMin'].value || 0
          end
        end
      end
    end
  end
end
