module Qti
  module ContentPackaging
    class OutcomeDeclaration < Dry::Struct
      transform_keys(&:to_sym)

      transform_types do |type|
        if type.default?
          type.constructor do |value|
            value.nil? ? Dry::Types::Undefined : value
          end
        else
          type
        end
      end
      attribute :identifier, Types::Strict::String
      attribute :baseType, Types::Strict::String
      attribute :cardinality, Types::Strict::String
      attribute :defaultValue, Types::Strict::String | Types::Coercible::Integer | Types::Coercible::Float
    end
  end
end
