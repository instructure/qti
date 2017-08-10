require 'spec_helper'

fixtures_path = File.join('spec', 'fixtures')

describe Qti::Models::Manifest do
  manifest_files = ['test_qti_1.2', 'test_qti_1.2_canvas', 'test_qti_2.1', 'test_qti_2.2']
  manifest_files.each do |mfile|
    file = File.join(fixtures_path, mfile, 'imsmanifest.xml')
    context "File: #{file}" do
      it 'parses the manifest file without error' do
        expect { described_class.from_path!(file) }.not_to raise_error
      end
    end
  end

  it 'returns a v1 assessment_test object if it finds a supported test file' do
    qti1_files = ['test_qti_1.2', 'test_qti_1.2_canvas']
    qti1_files.each do |qfile|
      file = File.join(fixtures_path, qfile, 'imsmanifest.xml')
      assessment_test = described_class.from_path!(file).assessment_test
      expect(assessment_test).to be_kind_of(Qti::V1::Models::Assessment)
    end
  end

  it 'returns a v2 assessment_test object if it finds a supported test file' do
    qti2_files = ['test_qti_2.1', 'test_qti_2.2']
    qti2_files.each do |qfile|
      file = File.join(fixtures_path, qfile, 'imsmanifest.xml')
      assessment_test = described_class.from_path!(file).assessment_test
      expect(assessment_test).to be_kind_of(Qti::V2::Models::AssessmentTest)
    end
  end

  it 'returns a v2 non assessment test if it is not a standard v2 package' do
    file = File.join(fixtures_path, 'no_assessment_XML/imsmanifest.xml')
    assessment_test = described_class.from_path!(file).assessment_test
    expect(assessment_test).to be_kind_of(Qti::V2::Models::NonAssessmentTest)
  end

  it 'raises a non-supported QTI type if it finds no other supported type' do
    file = File.join(fixtures_path, 'items_2.1/imsmanifest.xml')
    expect { described_class.from_path!(file).assessment_test }.to raise_error('Unsupported QTI version')
  end

end
