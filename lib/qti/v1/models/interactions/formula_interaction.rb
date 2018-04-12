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
              {
                inputs: vars_at_node(anode),
                output: anode.at_xpath('.//xmlns:answer').text
              }
            end
          end

          def variables
            varlist = @node.at_xpath('.//xmlns:vars')
            varlist.xpath('.//xmlns:var').map do |vnode|
              {
                name: vnode.attributes['name']&.value,
                min: vnode.at_xpath('.//xmlns:min').text,
                max: vnode.at_xpath('.//xmlns:max').text,
                precision: vnode.attributes['scale']&.value
              }
            end
          end

          def answer_tolerance
            @answer_tolernance ||= @node.at_xpath('.//xmlns:answer_tolerance').text
          end

          def margin_of_error
            if answer_tolerance.ends_with? '%'
              return { margin: answer_tolerance[0..-2], margin_type: 'percent' }
            end
            { margin: answer_tolerance, margin_type: 'absolute' }
          end

          def formula_decimal_places
            @node.at_xpath('.//xmlns:formulas/@decimal_places')&.value
          end

          def formulas
            node.xpath('.//xmlns:formula').map(&:text)
          end

          private

          def vars_at_node(parent_node)
            parent_node.xpath('.//xmlns:var').map do |vnode|
              {
                name: vnode.attributes['name']&.value,
                value: vnode.text
              }
            end
          end
        end
      end
    end
  end
end
