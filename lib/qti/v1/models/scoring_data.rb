module Qti
  module V1
    module Models
      ScoringData = Struct.new(:values, :rcardinality, :id, :case) do
        def initialize(values, rcardinality, options={})
          super(values, rcardinality, options[:id], options[:case])
        end
      end
    end
  end
end
