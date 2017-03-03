require 'dry-struct'

module Qti
  module ContentPackaging
    module Types
      include Dry::Types.module
    end
  end
end

require 'qti/content_packaging/outcome_declaration'
require 'qti/content_packaging/simple_choice'
require 'qti/content_packaging/choice_interaction'
require 'qti/content_packaging/assessment_item'
require 'qti/content_packaging/assessment_test'
