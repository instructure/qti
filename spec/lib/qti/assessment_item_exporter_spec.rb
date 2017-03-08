require 'spec_helper'

describe Qti::AssessmentItemExporter do
  let(:assessment_item) do
    Qti::ContentPackaging::AssessmentItem.new(
      identifier: '1', title: 'Question 1', response: 'true',
      interaction: Qti::ContentPackaging::ChoiceInteraction.new(
        prompt: 'Is 1+1 equals 2?', maxChoices: 1,
        choices: [
          Qti::ContentPackaging::SimpleChoice.new(
            identifier: 'true', body: 'True'
          ),
          Qti::ContentPackaging::SimpleChoice.new(
            identifier: 'false', body: 'False'
          )
        ]
      )
    )
  end

  describe '#export' do
    it 'generates the xml for an item' do
      dir = Dir.mktmpdir
      exporter = Qti::AssessmentItemExporter.new(assessment_item, package_root_path: dir)
      exporter.export

      expect(exporter.exported_file_path).to have_file_content(
        <<-XML.strip_heredoc
          <?xml version="1.0" encoding="UTF-8"?>
          <assessmentItem xmlns="http://www.imsglobal.org/xsd/imsqti_v2p2" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:m="http://www.w3.org/1998/Math/MathML" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/imsqti_v2p2 http://www.imsglobal.org/xsd/qti/qtiv2p2/imsqti_v2p2.xsd">
            <responseDeclaration identifier="RESPONSE" cardinality="single" baseType="identifier">
              <correctResponse>
                <value>true</value>
              </correctResponse>
            </responseDeclaration>
            <itemBody>
              <choiceInteraction responseIdentifier="RESPONSE" shuffle="false" maxChoices="1">
                <prompt>Is 1+1 equals 2?</prompt>
                <simpleChoice identifier="true" fixed="true">True</simpleChoice>
                <simpleChoice identifier="false" fixed="true">False</simpleChoice>
              </choiceInteraction>
            </itemBody>
          </assessmentItem>
        XML
      )
    end
  end
end
