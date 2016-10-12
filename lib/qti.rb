require 'find'

module Qti
  class Importer
    attr_reader :errored_files

    def initialize(path, qti_import = nil)
      Find.find(path) do |subdir|
        @path = subdir if subdir =~ /imsmanifest.xml/
      end
      @qti_import = qti_import
      @errored_files = []
    end

    def self.import!(path, quiz = nil, qti_import = nil)
      importer = new(path, qti_import)
      importer.import(quiz: quiz)
    end

    def import(quiz: nil)
    end

    private

  end
end

require 'qti/models/manifest'
require 'qti/models/base'

require 'qti/v1/models/base'
require 'qti/v1/models/assessment'
require 'qti/v1/models/assessment_item'
require 'qti/v1/models/choices/logical_identifier_choice'
require 'qti/v1/models/interactions/logical_identifier_interaction'

require 'qti/v2/models/base'
require 'qti/v2/models/choices/simple_choice'
require 'qti/v2/models/interactions/choice_interaction'
require 'qti/v2/models/assessment_item'
require 'qti/v2/models/assessment_test'
