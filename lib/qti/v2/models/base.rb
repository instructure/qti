require 'qti/models/base'

module Qti
  module V2
    module Models
      class Base < Qti::Models::Base
        BODY_ELEMENTS_CSS = %w(
          atomicBlock
          atomicInline
          caption
          choice
          col
          colgroup
          div
          dl
          dlElement
          hr
          img
          li
          object
          ol
          p
          printedVariable
          prompt
          simpleBlock
          simpleInline
          table
          tableCell
          tbody
          templateElement
          tfoot
          thead
          tr
          ul
          infoControl
        ).join(',').freeze

        INTERACTION_ELEMENTS_CSS = %w(
          blockInteraction
          customInteraction
          inlineInteraction
          positionObjectInteraction
          endAttemptInteraction
          inlineChoiceInteraction
          textEntryInteraction
          associateInteraction
          choiceInteraction
          drawingInteraction
          extendedTextInteraction
          gapMatchInteraction
          graphicInteraction
          hottextInteraction
          matchInteraction
          mediaInteraction
          orderInteraction
          sliderInteraction
          uploadInteraction
        ).join(',').freeze

        CHOICE_ELEMENTS_CSS = %w(
          simpleChoice
        ).join(',').freeze

        def qti_version
          2
        end
      end
    end
  end
end
