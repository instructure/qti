require 'spec_helper'

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

    it 'gets dependency file refs' do
      refs = loaded_class.assessment_item_reference_hrefs
      expect(refs.all? { |ref| File.extname(ref) == '.xml' })
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
    test_files << File.join(fixtures_path, 'tests', 'interactionmix_saxony_v3', 'InteractionMixSachsen_1901710679.xml')
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
          refs = loaded_class.assessment_item_reference_hrefs
          expect(refs.all? { |ref| File.extname(ref) == '.xml' })
        end
      end
    end
  end
end
