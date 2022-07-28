module Qti
  module ContentPackaging
    class SimpleChoice < Dry::Struct
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
      attribute :body, Types::Strict::String
      attribute :identifier, Types::Strict::String
      attribute :fixed, Types::Strict::Bool.default(true)
    end
  end
end
