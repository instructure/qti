module Qti
  module V2
    module Models
      ScoringData = Struct.new(:values, :type, :id, :case) do
        def initialize(values, rcardinality, options={})
          super(values, rcardinality, options[:id], options[:case])
        end
      end
    end
  end
end
