module Qti
  module V1
    module Models
      module Interactions
        class StringInteraction < BaseInteraction
          # This will know if a class matches
          def self.matches(node, parent)
            matches = node.xpath('.//xmlns:render_fib')
            return false if matches.empty?
            new(node, parent)
          end

          private

          def rcardinality
            @rcardinality ||= @node.at_xpath('.//xmlns:response_str/@rcardinality').value
          end
        end
      end
    end
  end
end
