module Qti
  module ContentPackaging
    class OutcomeDeclaration < Dry::Struct
      attribute :identifier, Types::Strict::String
      attribute :baseType, Types::Strict::String
      attribute :cardinality, Types::Strict::String
      attribute :defaultValue, Types::Strict::String | Types::Coercible::Int | Types::Coercible::Float
    end
  end
end
