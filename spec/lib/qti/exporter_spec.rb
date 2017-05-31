require 'spec_helper'

describe Qti::Exporter do
  let(:assessment_test) do
    Qti::ContentPackaging::AssessmentTest.new(
      title: 'Example test',
      items: [
        Qti::ContentPackaging::AssessmentItem.new(
          identifier: '0b8664be39cf69ef76402f3e41eb05', title: 'Question 1', response: 'true',
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

  describe '#export' do
    let(:dir) { Dir.mktmpdir }
    let(:exporter) { Qti::Exporter.new(assessment_test, package_root_path: dir) }

    before do
      exporter.export
    end

    context 'empty assessment' do
      let(:assessment_test) do
        Qti::ContentPackaging::AssessmentTest.new(
          title: 'Empty test',
          items: [],
          outcome_declarations: []
        )
      end

      it 'generates the xml for the empty assessment' do
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

    it 'generates the xml for an assessment with an item' do
      expect(exporter.exported_file_path).to contain_zip_entry('0b8664be39cf69ef76402f3e41eb05.xml')
      expect(exporter.exported_file_path).to have_zip_entry('assessment.xml').with_content(
        <<-XML.strip_heredoc
          <?xml version="1.0" encoding="UTF-8"?>
          <assessmentTest xmlns="http://www.imsglobal.org/xsd/imsqti_v2p2" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:m="http://www.w3.org/1998/Math/MathML" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/imsqti_v2p2 http://www.imsglobal.org/xsd/qti/qtiv2p2/imsqti_v2p2.xsd" title="Example test">
            <outcomeDeclaration baseType="float" cardinality="single" identifier="TEST_total">
              <defaultValue>
                <value>0</value>
              </defaultValue>
            </outcomeDeclaration>
            <outcomeDeclaration baseType="float" cardinality="single" identifier="S1">
              <defaultValue>
                <value>0</value>
              </defaultValue>
            </outcomeDeclaration>
            <testPart>
              <assessmentSection identifier="S1" visible="true" title="Section 1">
                <assessmentItemRef identifier="0b8664be39cf69ef76402f3e41eb05" href="0b8664be39cf69ef76402f3e41eb05.xml"/>
              </assessmentSection>
            </testPart>
          </assessmentTest>
        XML
      )
    end

    it 'generates the xml for the manifest' do
      expect(exporter.exported_file_path).to have_zip_entry('imsmanifest.xml').with_content(
        <<-XML.strip_heredoc
          <?xml version="1.0" encoding="UTF-8"?>
          <manifest xmlns="http://www.imsglobal.org/xsd/imscp_v1p1" xmlns:imsmd="http://ltsc.ieee.org/xsd/LOM" xmlns:imsqti="http://www.imsglobal.org/xsd/imsqti_v2p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/imscp_v1p1 http://www.imsglobal.org/xsd/qti/qtiv2p2/qtiv2p2_imscpv1p2_v1p0.xsdhttp://ltsc.ieee.org/xsd/LOM http://www.imsglobal.org/xsd/imsmd_loose_v1p3p2.xsdhttp://www.imsglobal.org/xsd/imsqti_metadata_v2p2http://www.imsglobal.org/xsd/qti/qtiv2p2/imsqti_metadata_v2p2.xsd">
            <metadata>
              <schema>QTIv2.2 Package</schema>
              <schemaversion>1.0.0</schemaversion>
              <imsmd:lom>
                <general>
                  <identifier>
                    <entry>FB-02</entry>
                  </identifier>
                  <title>
                    <string language="en">Example test</string>
                  </title>
                  <language>en</language>
                  <description>
                    <string language="en">Instructure QTI package.Feedback XML used as an example of unprocessable entity</string>
                  </description>
                </general>
                <imsmd:keyword>
                  <imsmd:string language="en">feedback</imsmd:string>
                </imsmd:keyword>
                <imsmd:keyword>
                  <imsmd:string language="en">modal</imsmd:string>
                </imsmd:keyword>
                <imsmd:keyword>
                  <imsmd:string language="en">test</imsmd:string>
                </imsmd:keyword>
                <imsmd:keyword>
                  <imsmd:string language="en">inline</imsmd:string>
                </imsmd:keyword>
                <imsmd:keyword>
                  <imsmd:string language="en">block</imsmd:string>
                </imsmd:keyword>
              </imsmd:lom>
            </metadata>
            <resources>
              <resource href="assessment.xml" type="imsqti_test_xmlv2p2" identifier="TEST">
                <file href="assessment.xml"/>
                <file href="0b8664be39cf69ef76402f3e41eb05.xml"/>
              </resource>
            </resources>
          </manifest>
        XML
      )
    end
  end
end
