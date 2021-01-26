require 'action_view'
require 'active_support/core_ext/array/access'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/module/delegation'
require 'dry-struct'
require 'find'
require 'forwardable'
require 'mathml2latex'
require 'nokogiri'
require 'pathname'
require 'sanitize'
require 'uri'
require 'zip'

module Qti
  class Importer
    attr_reader :package_root, :assessment_id

    delegate :assessment_identifiers, to: :@manifest
    delegate :question_bank_identifiers, to: :@manifest

    def initialize(path, assessment_id = nil)
      @path, @package_root, @manifest = Importer.manifest(path)
      @assessment_id = assessment_id || @manifest.assessment_identifiers.first
      @import = @manifest.assessment_test(@assessment_id)
    end

    def self.assessment_identifiers_for(path)
      manifest(path)[2].assessment_identifiers
    end

    def self.manifest_path(path)
      Find.find(path) do |subdir|
        return subdir if subdir =~ /imsmanifest.xml\z/
      end
      raise 'Manifest not found'
    end

    def self.manifest(path)
      mpath = manifest_path(path)
      package_root = File.dirname(mpath)
      manifest = Qti::Models::Manifest.from_path!(mpath, package_root: package_root)
      [mpath, package_root, manifest]
    end

    def test_object
      @import
    end

    def assessment_item_refs
      @import.assessment_items
    end

    def create_assessment_item(assessment_item)
      @import.create_assessment_item(assessment_item)
    end

    def stimulus_ref(assessment_item_ref)
      @import.stimulus_ref(assessment_item_ref)
    end

    def create_stimulus(stimulus_ref)
      @import.create_stimulus(stimulus_ref)
    end

    def create_question_group(question_group_ref)
      @import.create_question_group(question_group_ref)
    end
  end
end

# The load order of all of these is important.

require 'null_logger'

require 'qti/version'

require 'qti/assessment_item_exporter'
require 'qti/content_packaging'
require 'qti/exporter'
require 'qti/sanitizer'
require 'qti/xpath_helpers'

require 'qti/content_packaging/simple_choice'
require 'qti/content_packaging/choice_interaction'
require 'qti/content_packaging/assessment_item'
require 'qti/content_packaging/outcome_declaration'
require 'qti/content_packaging/assessment_test'

require 'qti/models/base'
require 'qti/models/assessment_meta'

require 'qti/v1/models/base'
require 'qti/v1/models/assessment'

require 'qti/v2/models/base'
require 'qti/v2/models/assessment_test'

require 'qti/models/metadata'
require 'qti/models/resource'
require 'qti/models/manifest'

require 'qti/v1/models/assessment_item'
require 'qti/v1/models/choices/logical_identifier_choice'
require 'qti/v1/models/choices/fill_blank_choice'
require 'qti/v1/models/object_bank'
require 'qti/v1/models/scoring_data'
require 'qti/v1/models/stimulus_item'
require 'qti/v1/models/question_group'

require 'qti/v1/models/interactions/base_interaction'
require 'qti/v1/models/interactions/choice_interaction'

require 'qti/v1/models/interactions/base_fill_blank_interaction'
require 'qti/v1/models/interactions/canvas_multiple_dropdown'
require 'qti/v1/models/interactions/fill_blank_interaction'
require 'qti/v1/models/interactions/formula_interaction'
require 'qti/v1/models/interactions/match_interaction'
require 'qti/v1/models/interactions/numeric_interaction'
require 'qti/v1/models/interactions/ordering_interaction'
require 'qti/v1/models/interactions/string_interaction'
require 'qti/v1/models/interactions/upload_interaction'

require 'qti/v1/models/interactions'

require 'qti/v1/models/numerics/scoring_base'

require 'qti/v1/models/numerics/exact_match'
require 'qti/v1/models/numerics/margin_error'
require 'qti/v1/models/numerics/precision'
require 'qti/v1/models/numerics/scoring_data'
require 'qti/v1/models/numerics/scoring_node'
require 'qti/v1/models/numerics/within_range'

require 'qti/v2/models/assessment_item'
require 'qti/v2/models/stimulus_item'
require 'qti/v2/models/interactions'
require 'qti/v2/models/non_assessment_test'
require 'qti/v2/models/scoring_data'

require 'qti/v2/models/interactions/base_interaction'

require 'qti/v2/models/interactions/categorization_interaction'
require 'qti/v2/models/interactions/choice_interaction'
require 'qti/v2/models/interactions/extended_text_interaction'
require 'qti/v2/models/interactions/gap_match_interaction'
require 'qti/v2/models/interactions/match_interaction'
require 'qti/v2/models/interactions/ordering_interaction'
require 'qti/v2/models/interactions/short_text_interaction'

require 'qti/v2/models/interactions/match_item_tag_processors/associate_interaction_tag_processor'
require 'qti/v2/models/interactions/match_item_tag_processors/match_interaction_tag_processor'

require 'qti/v2/models/choices/simple_choice'
require 'qti/v2/models/choices/simple_associable_choice'
require 'qti/v2/models/choices/gap_match_choice'
