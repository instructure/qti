require 'active_support/core_ext/hash/except'
# Populate the subclasses
Dir["#{__dir__}/interactions/*.rb"].each { |f| load f }

module Qti
  module V1
    module Models
      module Interactions
        ALL_CLASSES = constants.map { |c| const_get(c) }.freeze
        ORDERED_CLASSES = [CanvasMultipleDropdownInteraction, FormulaInteraction, NumericInteraction].freeze
        FALLBACK_CLASSES = [StringInteraction].freeze
        # This one finds the correct parsing model based on the provided xml node
        def self.interaction_model(node, parent)
          matches = Interactions.get_matches(node, parent, ORDERED_CLASSES)
          return matches.first unless matches.empty?

          subclasses = ALL_CLASSES - ORDERED_CLASSES - FALLBACK_CLASSES

          matches = Interactions.get_matches(node, parent, subclasses)
          matches = Interactions.get_matches(node, parent, FALLBACK_CLASSES) if matches.empty?

          raise UnsupportedSchema, "Multiple Types (#{matches.map(&:class)})" if matches.size != 1
          matches.first
        end

        def self.get_matches(node, parent, classlist)
          matches = classlist.each_with_object([]) do |interaction_class, result|
            match = interaction_class.matches(node, parent)
            result << match if match
          end
          matches
        end
      end
    end
  end
end
