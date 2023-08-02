module Qti
  module V1
    module Models
      ScoringData = Struct.new(:values, :rcardinality, :id, :case, :parent_identifier, :scoring_algorithm,
        :answer_type, :scoring_options) do
        def initialize(values, rcardinality, options = {})
          super(values, rcardinality, options[:id], options[:case], options[:parent_identifier],
                options[:scoring_algorithm], options[:answer_type], options[:scoring_options])
        end
      end
    end
  end
end
