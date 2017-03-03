require 'spec_helper'

describe Qti::Exporter do
  let(:empty_assessment_test) do
    Qti::ContentPackaging::AssessmentTest.new(
      title: 'Empty test',
      items: [],
      outcome_declarations: []
    )
  end

  let(:assessment_test) do
    Qti::ContentPackaging::AssessmentTest.new(
      title: 'Example test',
      items: [
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
      ],
      outcome_declarations: [
        Qti::ContentPackaging::OutcomeDeclaration.new(
          identifier: 'TEST_total', baseType: 'float', cardinality: 'single', defaultValue: 0.0
        ),
        Qti::ContentPackaging::OutcomeDeclaration.new(
          identifier: 'S1', baseType: 'float', cardinality: 'single', defaultValue: 0.0
        )
      ]
    )
  end

  describe '#assessment_xml_string' do
    it 'generates the xml for the empty assessment' do
      dir = Dir.mktmpdir

      exporter = Qti::Exporter.new(empty_assessment_test, package_root_path: dir)
      exporter.export

      expect(exporter.exported_file_path).to have_zip_entry('assessment.xml').with_content(
        <<-XML.strip_heredoc
          <?xml version="1.0" encoding="UTF-8"?>
          <assessmentTest xmlns="http://www.imsglobal.org/xsd/imsqti_v2p2" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:m="http://www.w3.org/1998/Math/MathML" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/imsqti_v2p2 http://www.imsglobal.org/xsd/qti/qtiv2p2/imsqti_v2p2.xsd" title="Empty test">
            <testPart/>
          </assessmentTest>
        XML
      )
    end
  end

  it 'creates the zip file' do
    dir = Dir.mktmpdir

    exporter = Qti::Exporter.new(assessment_test, package_root_path: dir)
    exporter.export

    expect(File.exist?(exporter.exported_file_path)).to be_truthy
  end

  it 'contains an imsnanifest.xml and an assessment.xml files' do
    dir = Dir.mktmpdir

    exporter = Qti::Exporter.new(assessment_test, package_root_path: dir)
    exporter.export

    Zip::File.open(exporter.exported_file_path, 'r') do |zip_file|
      expect(zip_file.glob('imsmanifest.xml').first).to be_present
      expect(zip_file.glob('assessment.xml').first).to be_present
      expect(zip_file.glob('item-1.xml').first).to be_present
    end
  end
end
