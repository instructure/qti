module Qti
  module ContentPackaging
    class AssessmentItem < Dry::Struct
      constructor_type :schema

      attribute :identifier, Types::Strict::String
      attribute :title, Types::Strict::String
      attribute :interaction, ContentPackaging::ChoiceInteraction
      attribute :response, Types::Strict::Array.of(String) | Types::Strict::String
    end
  end
end
