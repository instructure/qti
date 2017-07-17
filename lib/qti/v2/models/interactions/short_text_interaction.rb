module Qti
  module V2
    module Models
      module Interactions
        class ShortTextInteraction < BaseInteraction
          # This will know if a class matches
          def self.matches(node)
            matches = node.xpath('.//xmlns:textEntryInteraction')
            return false if matches.empty?

            raise Qti::UnsupportedSchema if matches.size > 1
            new(matches.first)
          end
        end
      end
    end
  end
end
