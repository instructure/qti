require 'spec_helper'

describe Qti::V2::Models::StimulusItem do
  let(:file_path) { File.join('spec', 'fixtures', 'no_assessment_XML', 'imsmanifest.xml') }
  let(:test_object) { Qti::V2::Models::NonAssessmentTest.from_path!(file_path) }
  let(:stimulus_ref) { test_object.stimulus_ref(test_object.assessment_items[1]) }
  let(:loaded_class) { described_class.new(path: stimulus_ref, html: true) }

  it 'loads a stimulus ref' do
    expect do
      described_class.from_path!(stimulus_ref)
    end.to_not raise_error
  end

  it 'has the title' do
    expect(loaded_class.title).to eq '¡El equipo de hockey te necesita!'
  end

  it 'has sanitized item_body' do
    expect(loaded_class.body).to include '<div'
    expect(loaded_class.body).to include 'Listen to the audio passage.'
    expect(loaded_class.body).to include '¡'
  end

  it 'has the identifier used to identify it in manifest file' do
    expect(loaded_class.identifier).to eq '0cfd5cf7-2c91-4b35-a57a-9f5d1709f68f'
  end
end
