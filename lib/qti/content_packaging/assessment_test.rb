module Qti
  module ContentPackaging
    class AssessmentTest < Dry::Struct
      constructor_type :schema

      attribute :identifier, Types::Strict::String
      attribute :title, Types::Strict::String
      attribute :items, Types::Strict::Array.of(ContentPackaging::AssessmentItem)
      attribute :outcome_declarations, Types::Strict::Array.of(ContentPackaging::OutcomeDeclaration)
    end
  end
end
