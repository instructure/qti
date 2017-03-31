require 'find'

module Qti
  class Importer
    def initialize(path)
      Find.find(path) do |subdir|
        @path = subdir if subdir =~ /imsmanifest.xml/
      end
    end

    def import_manifest
      @manifest = Qti::Models::Manifest.from_path!(@path)
      raise 'Unsupported QTI version' if @manifest.assessment_test_href.nil?
      @manifest.assessment_test_href
    end

    def test_object
      version_agnostic_test_object(import_manifest)
    end

    def version_agnostic_test_object(assessment_test_file)
      if @manifest.qti_1_href
        Qti::V1::Models::Assessment.from_path!(assessment_test_file)
      else
        Qti::V2::Models::AssessmentTest.from_path!(assessment_test_file)
      end
    end

    def assessment_item_refs
      @assessment_item_refs ||= begin
        if @manifest.qti_1_href
          test_object.assessment_items
        else
          test_object.assessment_item_reference_hrefs
        end
      end
    end

    def create_assessment_item(assessment_item_ref)
      if @manifest.qti_1_href
        Qti::V1::Models::AssessmentItem.new(assessment_item_ref)
      else
        Qti::V2::Models::AssessmentItem.from_path!(assessment_item_ref)
      end
    end
  end
end

require 'active_support/core_ext/string'

require 'qti/models/manifest'
require 'qti/models/base'

require 'qti/v1/models/base'
require 'qti/v1/models/interactions/base_interaction'
require 'qti/v1/models/interactions/choice_interaction'
require 'qti/v1/models/assessment'
require 'qti/v1/models/assessment_item'
require 'qti/v1/models/choices/logical_identifier_choice'
require 'qti/v1/models/scoring_data'

require 'qti/v2/models/base'
require 'qti/v2/models/interactions/base_interaction'
require 'qti/v2/models/choices/simple_choice'
require 'qti/v2/models/choices/simple_associable_choice'
require 'qti/v2/models/assessment_item'
require 'qti/v2/models/assessment_test'
require 'qti/v2/models/scoring_data'

require 'zip'
require 'qti/exporter'

require 'qti/content_packaging'
require 'qti/assessment_item_exporter'

require 'null_logger'
