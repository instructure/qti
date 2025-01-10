module Qti
  module V1
    module Models
      module Interactions
        class HotSpotInteraction < BaseInteraction
          def self.matches(node, parent)
            presentation = node.at_xpath('.//xmlns:presentation')
            return false unless presentation
            xy_responses = presentation.xpath('.//xmlns:response_xy')
            return false unless xy_responses.count.positive?
            new(node, parent)
          end

          def item_body
            @item_body ||= begin
              node = @node.dup
              presentation = node.at_xpath('.//xmlns:presentation')
              mattext = presentation.at_xpath('.//xmlns:mattext')
              inner_content = return_inner_content!(mattext)
              sanitize_content!(inner_content)
            end
          end

          def image_url
            @image_url ||= begin
              node = @node.dup
              presentation = node.at_xpath('.//xmlns:presentation')
              matimage = presentation.at_xpath('.//xmlns:matimage')
              matimage&.attributes&.[]('uri')&.value
            end
          end

          def shape_type
            @shape_type ||= extract_shape_type(response_label)
          end

          def coordinates
            @coordinates ||= parse_coordinates(raw_coordinates)
          end

          def scoring_data_structs
            @scoring_data_structs ||= parse_scoring_data
          end

          private

          def parse_scoring_data
            raw_scoring_data = answer_nodes&.map do |answer|
              {
                id: extract_identifier(answer),
                type: extract_shape_type(answer),
                coordinates: parse_coordinates(answer&.text || '')
              }
            end
            raw_scoring_data.map do |values|
              Models::ScoringData.new(values, rcardinality)
            end
          end

          def response_label
            @response_label ||= begin
              node = @node.dup
              presentation = node.at_xpath('.//xmlns:presentation')
              presentation.at_xpath('.//xmlns:response_label')
            end
          end

          def answer_nodes
            @answer_nodes ||= begin
              node = @node.dup
              presentation = node.at_xpath('.//xmlns:presentation')
              presentation.xpath('.//xmlns:response_label')
            end
          end

          def raw_coordinates
            @raw_coordinates ||= response_label&.text || ''
          end

          def extract_shape_type(answer)
            answer&.attributes&.[]('rarea')&.value
          end

          def extract_identifier(answer)
            answer&.attributes&.[]('ident')&.value
          end

          def parse_coordinates(raw_coordinates)
            raw_coordinates_array = raw_coordinates.split(',')
            return [] unless (raw_coordinates_array.length % 2).zero?

            raw_coordinates_array.each_slice(2).map do |point|
              { x: point[0].to_f, y: point[1].to_f }
            end
          end

          def coordinate_hash(coordinate_node)
            %w[x y].map do |axis|
              [axis.to_sym, coordinate_node&.attributes&.[](axis)&.value&.to_f]
            end.to_h
          end
        end
      end
    end
  end
end
