require 'qti/v1/models/base'
require 'qti/v1/models/choices/logical_identifier_choice'

module Qti
  module V1
    module Models
      module Interactions
        class LogicalIdentifierInteraction < Qti::V1::Models::Base
          NODE_NAME = 'response_lid'.freeze
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
