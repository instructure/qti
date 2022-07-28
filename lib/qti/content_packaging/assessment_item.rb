module Qti
  module ContentPackaging
    class AssessmentItem < Dry::Struct
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
      attribute :title, Types::Strict::String
      attribute :interaction, ContentPackaging::ChoiceInteraction
      attribute :response, Types::Strict::Array.of(Types::Strict::String) | Types::Strict::String
    end
  end
end
