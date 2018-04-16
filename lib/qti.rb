require 'find'

module Qti
  class Importer
    attr_reader :package_root

    def initialize(path)
      Find.find(path) do |subdir|
        if subdir =~ /imsmanifest.xml\z/
          @path = subdir
          break
        end
      end
      raise 'Manifest not found' unless @path
      @package_root = File.dirname(@path)
      @import = Qti::Models::Manifest.from_path!(@path, @package_root).assessment_test
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
  end
end

require 'active_support/core_ext/string'

require 'qti/models/manifest'
require 'qti/models/base'

require 'qti/v1/models/base'
require 'qti/v1/models/interactions/base_interaction'
require 'qti/v1/models/interactions/base_fill_blank_interaction'
require 'qti/v1/models/interactions/choice_interaction'

require 'qti/v1/models/assessment'
require 'qti/v1/models/assessment_item'
require 'qti/v1/models/choices/logical_identifier_choice'
require 'qti/v1/models/choices/fill_blank_choice'
require 'qti/v1/models/scoring_data'

require 'qti/v1/models/numerics/exact_match'
require 'qti/v1/models/numerics/margin_error'
require 'qti/v1/models/numerics/precision'
require 'qti/v1/models/numerics/scoring_data'
require 'qti/v1/models/numerics/scoring_node'
require 'qti/v1/models/numerics/within_range'

require 'qti/v2/models/base'
require 'qti/v2/models/choices/simple_choice'
require 'qti/v2/models/choices/simple_associable_choice'
require 'qti/v2/models/choices/gap_match_choice'
require 'qti/v2/models/assessment_item'
require 'qti/v2/models/stimulus_item'
require 'qti/v2/models/assessment_test'
require 'qti/v2/models/non_assessment_test'
require 'qti/v2/models/scoring_data'

require 'zip'
require 'qti/exporter'

require 'qti/content_packaging'
require 'qti/assessment_item_exporter'

require 'null_logger'
