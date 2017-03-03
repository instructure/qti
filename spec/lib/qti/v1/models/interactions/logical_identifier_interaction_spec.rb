require 'spec_helper'

describe Qti::V1::Models::Interactions::LogicalIdentifierInteraction do
  context 'quiz.xml' do
    let(:fixtures_path) { File.join('spec', 'fixtures') }
    let(:file_path) { File.join(fixtures_path, 'test_qti_1.2', 'quiz.xml') }
    let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
    let(:assessment_item_refs) { test_object.assessment_items }
    let(:loaded_class) { described_class.new(assessment_item_refs.first) }

    it 'returns shuffle setting' do
      expect(loaded_class.shuffled?).to eq true
    end

    it 'returns the answers' do
      expect(loaded_class.answers.count).to eq 2
      expect(loaded_class.answers.first).to be_an_instance_of(Qti::V1::Models::Choices::LogicalIdentifierChoice)
    end
  end
end
