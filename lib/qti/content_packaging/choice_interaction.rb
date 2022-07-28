module Qti
  module ContentPackaging
    class ChoiceInteraction < Dry::Struct
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
      attribute :prompt, Types::Strict::String
      attribute :shuffle, Types::Strict::Bool.default(false)
      attribute :maxChoices, Types::Coercible::Integer
      attribute :choices, Types::Strict::Array.of(ContentPackaging::SimpleChoice)
    end
  end
end
