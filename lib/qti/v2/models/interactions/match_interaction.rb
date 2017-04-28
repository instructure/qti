require_relative 'match_item_tag_processors/match_interaction_tag_processor'
require_relative 'match_item_tag_processors/associate_interaction_tag_processor'

module Qti
  module V2
    module Models
      module Interactions
        class MatchInteraction < BaseInteraction
          extend Forwardable

          attr_reader :implementation

          def initialize(node, implementation)
            super(node)
            @implementation = implementation.new(node)
          end

          def_delegators :@implementation, :answers, :questions, :shuffled?

          def scoring_data_structs
            implementation.scoring_data_structs
          end

          def self.matches(node)
            implementation =
              if use_associate_interaction_implementation?(node)
                MatchItemTagProcesssors::AssociateInteractionTagProcessor
              elsif use_match_interaction_implementation?(node)
                MatchItemTagProcesssors::MatchInteractionTagProcessor
              end

            return false unless implementation.present?
            new(node, implementation)
          end

          def self.use_associate_interaction_implementation?(node)
            MatchItemTagProcesssors::AssociateInteractionTagProcessor.associate_interaction_tag?(node) &&
              MatchItemTagProcesssors::AssociateInteractionTagProcessor.number_of_questions_per_answer(node)
                                                                       .all? { |n| n == 1 }
          end

          def self.use_match_interaction_implementation?(node)
            MatchItemTagProcesssors::MatchInteractionTagProcessor.match_interaction_tag?(node) &&
              MatchItemTagProcesssors::MatchInteractionTagProcessor.number_of_questions_per_answer(node)
                                                                   .all? { |n| n == 1 }
          end
        end
      end
    end
  end
end
