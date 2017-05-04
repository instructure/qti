module Qti
  module V2
    module Models
      module Interactions
        class GapMatchInteraction < BaseInteraction
          def self.matches(node)
            matches = node.xpath('.//xmlns:gapMatchInteraction')
            return false if matches.count != 1
            new(node)
          end

          def initialize(node)
            @node = node
          end

          def shuffled?
            @node.at_xpath('.//xmlns:gapMatchInteraction').attributes['shuffle']&.value.try(:downcase) == 'true'
          end

          def clean_stem_items
            @clean_stem_items ||= begin
              node = @node.dup
              gap_node = node.xpath('.//xmlns:gapMatchInteraction')
              gap_node.children.filter('gapText').each(&:remove)

              gap_node.children.each do |child|
                if child.inner_text.strip.empty?
                  child.remove
                end
              end

              gap_node
            end
          end

          def prompt
            clean_stem_items.children.filter('prompt')
          end

          def stem_items
            if prompt.present?
              stem_text_with_prompt = stem_text.unshift(prompt_hash)
              stem_items_with_id_and_position(stem_text_with_prompt)
            else
              stem_items_with_id_and_position(stem_text)
            end
          end

          def stem_items_with_id_and_position(stem_text)
            stem_text.map.with_index do |stem_item, index|
              stem_item.merge(
                id: "stem_#{index}",
                position: index + 1
              )
            end
          end

          def prompt_hash
            {
              type: 'text',
              value: prompt.first.text
            }
          end

          def stem_text
            clean_stem_items.search('p').children.map do |stem_item|
              if stem_item.name == 'gap'
                {
                  type: 'blank',
                  blank_id: stem_item.attributes['identifier'].value
                }
              else
                {
                  type: 'text',
                  value: stem_item.text.empty? ? " " : stem_item.text
                }
              end
            end
          end

          def blanks
            node.xpath('.//xmlns:gapText').map do |blank|
              { id: blank.attributes['identifier'].value }
            end
          end

          def answers
            @answers ||= answer_nodes.map do |node|
              V2::Models::Choices::GapMatchChoice.new(node)
            end
          end

          def scoring_data_structs
            question_response_pairs = node.xpath('.//xmlns:correctResponse//xmlns:value').map do |value|
              value.content.split
            end
            question_response_pairs.map!{ |qrp| qrp.reverse }
            question_response_id_mapping = Hash[question_response_pairs]
            answer_nodes.map { |value_node|
              node_id = value_node.attributes['identifier']&.value
              answer_choice = choices.find{ |choice| choice.attributes['identifier']&.value == question_response_id_mapping[node_id] }
              ScoringData.new(
                answer_choice.content,
                'directedPair',
                {
                  id: node_id,
                  case: false
                }
              )
            }
          end

          def choices
            @node.xpath('.//xmlns:gapText')
          end

          private

          def answer_nodes
            @node.xpath('.//xmlns:gap')
          end
        end
      end
    end
  end
end
