module Qti
  module ContentPackaging
    class AssessmentTest < Dry::Struct
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
      attribute :items, Types::Strict::Array.of(ContentPackaging::AssessmentItem)
      attribute :outcome_declarations, Types::Strict::Array.of(ContentPackaging::OutcomeDeclaration)
    end
  end
end
