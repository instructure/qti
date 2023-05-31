module Qti
  module V1
    module Models
      class AssessmentItem < Qti::V1::Models::Base
        attr_reader :doc, :resource

        delegate :metadata, to: :@resource

        def initialize(item, package_root = nil, resource = nil)
          @doc = item
          @path = item.document.url
          @resource = resource
          self.package_root = package_root
        end

        def item_body
          @item_body ||= begin
            node = @doc.dup
            presentation = node.at_xpath('.//xmlns:presentation')
            mattext = presentation.at_xpath('.//xmlns:mattext')
            prompt = sanitize_attributes(return_inner_content!(mattext))
            sanitize_content!(prompt)
          end
        end

        def identifier
          @identifier ||= @doc.attribute('ident').value
        end

        def title
          @title ||= @doc.attribute('title')&.value
        end

        def qti_metadata_children
          @doc.at_xpath('.//xmlns:qtimetadata')&.children
        end

        def points_possible_qti_metadata?
          if @doc.at_xpath('.//xmlns:qtimetadata').present?
            points_possible_label = qti_metadata_children.children.find { |node| node.text == 'points_possible' }
            points_possible_label.present?
          else
            false
          end
        end

        # @deprecated Please use {#points_possible_qti_metadata?} instead
        def has_points_possible_qti_metadata? # rubocop:disable Naming/PredicateName
          warn "DEPRECATED: '#{__method__}' is renamed to 'points_possible_qti_metadata?'."
          points_possible_qti_metadata?
        end

        def points_possible
          @points_possible ||= begin
            if points_possible_qti_metadata?
              points_possible_label = qti_metadata_children.children.find do |node|
                node.text == 'points_possible'
              end
              points_possible_label.next.text
            else
              1
            end
          end
        end

        def parent_stimulus_item_ident_metadata?
          if @doc.at_xpath('.//xmlns:qtimetadata').present?
            qti_metadata_children.children.find do |node|
              node.text == 'parent_stimulus_item_ident'
            end.present?
          else
            false
          end
        end

        def parent_stimulus_item_ident
          @parent_stimulus_item_ident ||= begin
            if parent_stimulus_item_ident_metadata?
              parent_stimulus_item_ident_label = qti_metadata_children.children.find do |node|
                node.text == 'parent_stimulus_item_ident'
              end
              parent_stimulus_item_ident_label.next.text
            end
          end
        end

        def decvar_maxvalue
          @doc.at_xpath('.//xmlns:decvar/@maxvalue')&.value&.to_i ||
            @doc.at_xpath('.//xmlns:decvar/@defaultval')&.value&.to_i || 0
        end

        def rcardinality
          @rcardinality ||= @doc.at_xpath('.//xmlns:response_lid/@rcardinality').value
        end

        def interaction_model
          @interaction_model ||= begin
            V1::Models::Interactions.interaction_model(@doc, self)
          end
        end

        def scoring_data_structs
          @scoring_data_structs ||= interaction_model.scoring_data_structs
        end

        def feedback
          @feedback ||= interaction_model.canvas_item_feedback&.transform_values { |v| sanitize_content!(v) }
        end

        def answer_feedback
          @answer_feedback ||= interaction_model.answer_feedback&.map do |answer|
            duped = answer.dup
            duped[:feedback] = sanitize_content!(duped[:feedback])
            duped
          end
        end
      end
    end
  end
end
