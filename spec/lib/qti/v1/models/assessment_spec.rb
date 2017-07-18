require 'spec_helper'

fixtures_path = File.join('spec', 'fixtures')

describe Qti::V1::Models::Assessment do
  let(:path) { File.join(fixtures_path, 'test_qti_1.2', 'quiz.xml') }
  let(:loaded_class) { described_class.from_path!(path) }

  it 'loads an AssessmentXML file' do
    expect do
      described_class.from_path!(path)
    end.to_not raise_error
  end

  describe '#title' do
    context '<assessmentTest> has a title property' do
      it 'has the title' do
        expect(loaded_class.title).to eq '1.2 Import Quiz'
      end
    end

    context '<assessmentTest> has no title property' do
      it 'sets the title to the filename by default' do
        empty_test_string =
            <<-XML.strip_heredoc
              <?xml version="1.0" encoding="UTF-8"?>
              <questestinterop xmlns="http://www.imsglobal.org/xsd/ims_qtiasiv1p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd">
                <assessment ident="A1001">
                </assessment>
              </questestinterop>
            XML
        allow(File).to receive(:read).and_return(empty_test_string)
        assessment_test = described_class.new path: '/a/b/c/Test123.xml'
        expect(assessment_test.title).to eq 'Test123'
      end
    end
  end
end
