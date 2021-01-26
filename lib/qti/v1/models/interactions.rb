module Qti
  module V1
    module Models
      module Interactions
        ALL_CLASSES = constants.map { |c| const_get(c) }.freeze
        ORDERED_CLASSES = [CanvasMultipleDropdownInteraction, FormulaInteraction, NumericInteraction].freeze
        FALLBACK_CLASSES = [StringInteraction].freeze
        IDENTIFIED_CLASSES = {
          'multiple_choice_question' => ChoiceInteraction,
          'true_false_question' => ChoiceInteraction,
          'short_answer_question' => FillBlankInteraction,
          'fill_in_multiple_blanks_question' => FillBlankInteraction,
          'multiple_answers_question' => ChoiceInteraction,
          'multiple_dropdowns_question' => CanvasMultipleDropdownInteraction,
          'matching_question' => MatchInteraction,
          'numerical_question' => NumericInteraction,
          'calculated_question' => FormulaInteraction,
          'essay_question ' => StringInteraction,
          'file_upload_question' => UploadInteraction
          # "text_only_question" => StimulusNoQuestion
        }.freeze

        # This one finds the correct parsing model based on the provided xml node

        def self.interaction_model(node, parent)
          matched_class(node, parent) || searched_class(node, parent)
        end

        def self.searched_class(node, parent)
          matches = Interactions.get_matches(node, parent, ORDERED_CLASSES)
          return matches.first unless matches.empty?

          subclasses = ALL_CLASSES - ORDERED_CLASSES - FALLBACK_CLASSES

          matches = Interactions.get_matches(node, parent, subclasses)
          matches = Interactions.get_matches(node, parent, FALLBACK_CLASSES) if matches.empty?

          raise UnsupportedSchema, "Multiple Types (#{matches.map(&:class)})" if matches.size != 1
          matches.first
        end

        def self.matched_class(node, parent)
          IDENTIFIED_CLASSES[question_type(node)]&.new(node, parent)
        end

        def self.question_type(node)
          path = './/xmlns:qtimetadatafield/xmlns:fieldlabel' \
            '[text()="question_type"]/../xmlns:fieldentry'
          node.at_xpath(path)&.text
        end

        def self.get_match(node, parent, classlist)
          classlist.each do |interaction_class|
            return true if interaction_class.match(node, parent)
          end
        end

        def self.get_matches(node, parent, classlist)
          classlist.each_with_object([]) do |interaction_class, result|
            match = interaction_class.matches(node, parent)
            result << match if match
          end
        end
      end
    end
  end
end
