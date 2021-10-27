module Qti
  module V1
    module Models
      class ObjectBank < Qti::V1::Models::Assessment
        # use assessment_items / create_assessment_item from Assessment for bank items
        def title
          @title ||= xpath_with_single_check(
            './/xmlns:qtimetadatafield/xmlns:fieldlabel[text()="bank_title"]/../xmlns:fieldentry'
          )&.content || File.basename(@path, '.xml')
        end

        def identifier
          @identifier ||= xpath_with_single_check('.//xmlns:objectbank/@ident')&.content
        end

        # tells us whether the bank was an account or course bank
        def bank_type
          @bank_type ||= xpath_with_single_check(
            './/xmlns:qtimetadatafield/xmlns:fieldlabel[text()="bank_type"]/../xmlns:fieldentry'
          )&.content
        end
      end
    end
  end
end
