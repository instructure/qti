module Qti
  module V1
    module Models
      module Interactions
        class FormulaInteraction < BaseInteraction
          # This will know if a class matches

          def self.matches(node, parent)
            return false unless node.at_xpath('.//xmlns:calculated').present?
            new(node, parent)
          end

          def scoring_data_structs
            solutions.map do |answer|
              ScoringData.new(
                answer[:output],
                rcardinality,
                id: answer[:id]
              )
            end
          end

          def solutions
            node.xpath('.//xmlns:var_set').map do |anode|
              output = anode.at_xpath('.//xmlns:answer')&.text

              {
                inputs: vars_at_node(anode),
                output: formula_scientific_notation ? output : output&.to_f
              }
            end
          end

          def variables
            varlist = @node.at_xpath('.//xmlns:vars')
            varlist.xpath('.//xmlns:var').map do |vnode|
              variable_def(vnode)
            end
          end

          def answer_tolerance
            @answer_tolerance ||= @node.at_xpath('.//xmlns:answer_tolerance').text
          end

          def margin_of_error
            return { margin: answer_tolerance[0..-2], margin_type: 'percent' } if answer_tolerance.ends_with? '%'
            { margin: answer_tolerance, margin_type: 'absolute' }
          end

          def formula_decimal_places
            @node.at_xpath('.//xmlns:formulas/@decimal_places')&.value
          end

          def formula_scientific_notation
            @node.at_xpath('.//xmlns:formulas/@scientific_notation')&.value == 'true'
          end

          def formulas
            node.xpath('.//xmlns:formula').map(&:text)
          end

          private

          def vars_at_node(parent_node)
            parent_node.xpath('.//xmlns:var').map do |vnode|
              {
                name: vnode.attributes['name']&.value,
                value: vnode.text&.to_f
              }
            end
          end

          def variable_def(var_node)
            {
              name: var_node.attributes['name']&.value,
              min: var_node.at_xpath('.//xmlns:min').text&.to_f,
              max: var_node.at_xpath('.//xmlns:max').text&.to_f,
              precision: var_node.attributes['scale']&.value&.to_i
            }
          end
        end
      end
    end
  end
end
