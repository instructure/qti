module Qti
  class AssessmentItemExporter
    attr_reader :assessment_item, :package_root_path

    def initialize(assessment_item, args = {})
      @assessment_item = assessment_item
      @package_root_path = args[:package_root_path] || '.'
    end

    def exported_file_path
      @exported_file_path ||= File.join(package_root_path, "#{assessment_item.identifier}.xml")
    end

    def export
      File.open(exported_file_path, 'wb') do |f|
        f.write xml_string_for_assessment_item
      end
    end

    private

    def xml_string_for_assessment_item
      Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.assessmentItem(assesment_item_attributes) do
          xml.responseDeclaration('identifier' => 'RESPONSE',
                                  'cardinality' => cardinality_for_response(assessment_item),
                                  'baseType' => 'identifier') do
            xml.correctResponse do
              xml.value assessment_item.response
            end
          end
          xml_assessment_item_body(xml, assessment_item)
        end
      end.to_xml
    end

    def cardinality_for_response(assessment_item)
      if assessment_item.response.is_a? Array
        'multiple'
      else
        'single'
      end
    end

    def xml_assessment_item_body(xml, assessment_item)
      xml.itemBody do
        xml.choiceInteraction(interaction_params(assessment_item.interaction)) do
          xml.prompt assessment_item.interaction.prompt
          assessment_item.interaction.choices.each do |choice|
            xml.simpleChoice(choice.body, 'identifier' => choice.identifier, 'fixed' => choice.fixed)
          end
        end
      end
    end

    def interaction_params(interaction)
      { 'responseIdentifier' => 'RESPONSE',
        'shuffle' => interaction.shuffle,
        'maxChoices' => interaction.maxChoices }
    end

    def assesment_item_attributes
      { 'xmlns' => 'http://www.imsglobal.org/xsd/imsqti_v2p2', 'xmlns:xi' => 'http://www.w3.org/2001/XInclude',
        'xmlns:m' => 'http://www.w3.org/1998/Math/MathML', 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://www.imsglobal.org/xsd/imsqti_v2p2 ' \
                                'http://www.imsglobal.org/xsd/qti/qtiv2p2/imsqti_v2p2.xsd',
        'timeDependent' => 'false', 'identifier' => "Item-#{assessment_item.identifier}",
        'title' => assessment_item.title }
    end
  end
end
