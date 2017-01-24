module Qti
  module V1
    module Models
      module Interactions
        class StringInteraction < Qti::V1::Models::Base
          NODE_NAME = 'response_str'.freeze
          # This will know if a class matches
          def self.matches(node)
            matches = node.children.children.select { |n| n.name == NODE_NAME }
            return false if matches.empty?

            raise Qti::UnsupportedSchema if matches.size > 1
            new(matches.first)
          end

          def initialize(node)
            @node = node
          end
        end
      end
    end
  end
end
