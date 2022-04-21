module Qti
  module ContentPackaging
    class OutcomeDeclaration < Dry::Struct
      constructor_type :schema

      attribute :identifier, Types::Strict::String
      attribute :baseType, Types::Strict::String
      attribute :cardinality, Types::Strict::String
      attribute :defaultValue, Types::Strict::String | Types::Coercible::Integer | Types::Coercible::Float
    end
  end
end
