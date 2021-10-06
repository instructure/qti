fixtures_path = File.join('spec', 'fixtures')

describe Qti::V2::Models::AssessmentTest do
  context 'test_qti_2.2' do
    let(:path) { File.join(fixtures_path, 'test_qti_2.2', 'assessment.xml') }
    let(:loaded_class) { described_class.from_path!(path) }

    it 'loads an AssessmentTest XML file' do
      expect do
        described_class.from_path!(path)
      end.to_not raise_error
    end

    it 'has the title' do
      expect(loaded_class.title).to eq 'Simple Feedback Test'
    end

    it 'has the identifier' do
      expect(loaded_class.identifier).to eq 'SPECTATUS-GENERATED-TEST'
    end

    it 'gets dependency file refs' do
      refs = loaded_class.assessment_items
      expect(refs.all? { |ref| File.extname(ref[:path]) == '.xml' })
    end

    it 'loads up some testParts' do
      expect(loaded_class.test_parts).not_to be_nil
    end

    it 'loads up some assessment Sections' do
      expect(loaded_class.assessment_sections).not_to be_nil
    end
  end

  context 'all test files' do
    test_files = Dir.glob(File.join(fixtures_path, 'tests', 'tests', 'rtest[0-9][0-9].xml'))
    test_files << File.join(fixtures_path, 'tests', 'tests', 'complete.xml')
    test_files << File.join(fixtures_path, 'tests', 'feedbackTest', 'assessment.xml')
    test_files << File.join(
      fixtures_path, 'tests',
      'interactionmix_saxony_v3',
      'InteractionMixSachsen_1901710679.xml'
    )
    test_files.each do |file|
      context File.basename(file) do
        let(:loaded_class) { described_class.from_path!(file) }

        it 'loads an AssessmentTest XML file' do
          expect do
            described_class.from_path!(file)
          end.to_not raise_error
        end

        it 'has a title' do
          expect(loaded_class.title).to be_a String
        end

        it 'gets dependency file refs' do
          refs = loaded_class.assessment_items
          expect(refs.all? { |ref| File.extname(ref[:path]) == '.xml' })
        end
      end
    end
  end

  describe '#title' do
    it 'sets the title to the filename by default' do
      allow(File).to receive(:read).and_return(<<~XML)
        <?xml version="1.0" encoding="UTF-8"?>
        <assessmentTest xmlns="http://www.imsglobal.org/xsd/imsqti_v2p2p1" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:m="http://www.w3.org/1998/Math/MathML" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/imsqti_v2p2 http://www.imsglobal.org/xsd/qti/qtiv2p2/imsqti_v2p2.xsd">
          <testPart identifier="Main" navigationMode="linear" submissionMode="individual"/>
        </assessmentTest>
      XML
      assessment_test = described_class.new path: '/a/b/c/Test123.xml'
      expect(assessment_test.title).to eq 'Test123'
    end
  end

  # describe '#create_stimulus' do
  #   let(:path) { File.join(fixtures_path, 'test_qti_2.2', 'assessment.xml') }
  #   let(:loaded_class) { described_class.from_path!(path) }

  #   it 'creates a stimulus from a given file' do
  #     stimulus_path = File.join(
  #       fixtures_path, 'no_assessment_XML',
  #       'passages', '0cfd5cf7-2c91-4b35-a57a-9f5d1709f68f.html'
  #     )
  #     stimulus = loaded_class.create_stimulus(stimulus_path)
  # rubocop:disable AsciiComments
  #     expect(stimulus.title).to eq '¡El equipo de hockey te necesita!'
  # rubocop:enable AsciiComments
  #   end
  # end
end
