module Qti
  module V2
    module Models
      ScoringData = Struct.new(:values, :type, :id, :case, :question_id, :questions_ids) do
        def initialize(values, type, options = {})
          super(values, type, options[:id], options[:case], options[:question_id], options[:questions_ids])
        end
      end
    end
  end
end
