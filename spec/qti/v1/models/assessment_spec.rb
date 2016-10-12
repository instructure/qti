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

  it 'has the title' do
    expect(loaded_class.title).to eq '1.2 Import Quiz'
  end
end
