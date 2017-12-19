module Qti
  module V1
    module Models
      ScoringData = Struct.new(:values, :rcardinality, :id, :case, :parent_identifier) do
        def initialize(values, rcardinality, options = {})
          super(values, rcardinality, options[:id], options[:case], options[:parent_identifier])
        end
      end
    end
  end
end
