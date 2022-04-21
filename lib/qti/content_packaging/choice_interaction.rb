module Qti
  module ContentPackaging
    class ChoiceInteraction < Dry::Struct
      constructor_type :schema

      attribute :prompt, Types::Strict::String
      attribute :shuffle, Types::Strict::Bool.default(false)
      attribute :maxChoices, Types::Coercible::Integer
      attribute :choices, Types::Strict::Array.of(ContentPackaging::SimpleChoice)
    end
  end
end
