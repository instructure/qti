module Qti
  module V1
    module Models
      module Interactions
        class LogicalIdentifierInteraction < Qti::V1::Models::Base
          # This will know if a class matches
          def self.matches(node)
            match = node.at_xpath('//response_lid')
            return false unless match.present?
            new(match)
          end

          def initialize(node)
            @node = node
          end

          def shuffled?
            @node.at_xpath('.//render_choice/@shuffle')&.value == 'Yes'
          end

          def answers
            @answers ||= answer_nodes.map do |node|
              V1::Models::Choices::LogicalIdentifierChoice.new(node)
            end
          end

          private

          def answer_nodes
            @node.xpath('.//response_label')
          end
        end
      end
    end
  end
end
