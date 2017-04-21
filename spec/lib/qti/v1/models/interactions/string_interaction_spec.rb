require 'spec_helper'

describe Qti::V1::Models::Interactions::StringInteraction do
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first) }

  context 'essay.xml' do
    let(:file_path) { File.join(fixtures_path, 'essay.xml') }
    let(:cardinality) { 'Single' }

    it 'returns loads the correct cardinality' do
      expect(loaded_class.send(:rcardinality)).to eq(cardinality)
    end
  end
end
