module Qti
  module ContentPackaging
    class SimpleChoice < Dry::Struct
      constructor_type :schema

      attribute :body, Types::Strict::String
      attribute :identifier, Types::Strict::String
      attribute :fixed, Types::Strict::Bool.default(true)
    end
  end
end
