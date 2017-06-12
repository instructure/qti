module Qti
  module ContentPackaging
    class AssessmentTest < Dry::Struct
      attribute :identifier, Types::Strict::String
      attribute :title, Types::Strict::String
      attribute :items, Types::Strict::Array.member(ContentPackaging::AssessmentItem)
      attribute :outcome_declarations, Types::Strict::Array.member(ContentPackaging::OutcomeDeclaration)
    end
  end
end
