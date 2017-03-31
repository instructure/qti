module Qti
  module V1
    module Models
      module Interactions
        class StringInteraction < BaseInteraction
          @node_name = 'response_str'.freeze
          # This will know if a class matches
          def self.matches(node)
            matches = node.children.children.select { |n| n.name == @node_name }
            return false if matches.empty?
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
