require 'spec_helper'

fixtures_path = File.join('spec', 'fixtures')

describe Qti::V2::Models::NonAssessmentTest do
  let(:path) { File.join(fixtures_path, 'no_assessment_XML', 'imsmanifest.xml') }
  let(:loaded_class) { described_class.from_path!(path) }

  it 'loads an AssessmentTest XML file' do
    expect do
      described_class.from_path!(path)
    end.to_not raise_error
  end

  describe '#stimulus_ref' do
    it 'should return the stimulus ref if it exists' do
      item = loaded_class.assessment_items[1]
      stimulus_ref = loaded_class.stimulus_ref(item)
      expect(stimulus_ref).to eq File.join(File.dirname(path), "passages/0cfd5cf7-2c91-4b35-a57a-9f5d1709f68f.html")
    end

    it 'should return nil if no stimulus ref' do
      item = loaded_class.assessment_items[0]
      stimulus_ref = loaded_class.stimulus_ref(item)
      expect(stimulus_ref).to be_nil
    end
  end
end
