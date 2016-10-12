require 'qti/models/base'

module Qti
  module V1
    module Models
      class Base < Qti::Models::Base
        def qti_version
          1
        end
      end
    end
  end
end
