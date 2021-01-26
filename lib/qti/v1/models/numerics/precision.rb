module Qti
  module V1
    module Models
      module Numerics
        class Precision < ScoringBase
          include ActionView::Helpers::NumberHelper

          def scoring_data
            return unless equal_node && gt_node && lte_node
            Struct.new(
              :id,
              :type,
              :value,
              :precision,
              :precision_type
            ).new(
              equal_node.attributes['respident']&.value,
              'preciseResponse',
              value,
              precision.to_s,
              'significantDigits'
            )
          end

          def value
            fval = equal_node.content.to_f
            number_with_precision(fval, precision: precision, significant: true)
          end

          def precision
            sig = [
              Precision.significant_digits(gt_node.content),
              Precision.significant_digits(lte_node.content)
            ].max
            sig - 1
          end

          def self.significant_digits(number_s)
            sig = 0
            zeros = 0
            number_s.each_char do |c|
              next if (sig.zero? && c == '0') || c == '.'
              if c == '0'
                zeros += 1
              else
                sig += zeros + 1
                zeros = 0
              end
            end
            # this is not exactly significant digits
            # trailing zeros are ignored
            # because gt_node and lte_node don't expect trailing zeros
            sig
          end
        end
      end
    end
  end
end
