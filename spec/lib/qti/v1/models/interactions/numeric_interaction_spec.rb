require 'spec_helper'

describe Qti::V1::Models::Interactions::NumericInteraction do
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:file_path) { File.join(fixtures_path, 'numeric.xml') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }

  shared_examples_for 'answers' do
    it 'returns the answers' do
      expect(loaded_class.answers.count).to eq answer_count
      expect(loaded_class.answers.first).to be_an_instance_of(Qti::V1::Models::Choices::FillBlankChoice)
    end
  end

  shared_examples_for 'scoring_data_structs' do
    it 'returns the scoring_data_structs' do
      expect(loaded_class.scoring_data_structs.map(&:id)).to eq(scoring_data_ids)
      expect(loaded_class.scoring_data_structs.map(&:values)).to eq(scoring_data_values)
    end
  end

  context 'the first item in numeric.xml' do
    let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
    let(:scoring_data_ids) { %w[response1] }
    let(:scoring_data_values) { %w[1234.0] }
    let(:answer_count) { 1 }

    include_examples 'answers'
    include_examples 'scoring_data_structs'
  end

  context 'the second item in numeric.xml' do
    let(:loaded_class) { described_class.new(assessment_item_refs[1], test_object) }
    let(:scoring_data_ids) { %w[response1 response1 response1] }
    let(:scoring_data_values) { %w[4321.0 1234.0 1111.0] }
    let(:answer_count) { 3 }

    include_examples 'answers'
    include_examples 'scoring_data_structs'
  end

  context '#item_body' do
    let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
    it 'returns right title' do
      expect(loaded_class.item_body).to eq '<div><p>question 1</p></div>'
    end
  end
end
