require 'spec_helper'

describe Qti::V1::Models::Interactions::OrderingInteraction do
  let(:file) { File.join('spec', 'fixtures', 'items_1.2', 'ordering.xml') }
  let(:assessment) { Qti::V1::Models::Assessment.from_path!(file) }
  let(:item) { assessment.assessment_items.first }
  subject { described_class.new(item, assessment) }

  describe '.matches' do
    it 'matches the item in file' do
      expect(described_class.matches(item, assessment)).to be_truthy
    end
  end

  describe '#scoring_data_structs' do
    it 'grabs scoring data value for ordering questions' do
      assessment_item = described_class.new(assessment.assessment_items.first, assessment)
      expect(assessment_item.scoring_data_structs.map(&:values)).to eq %w[A B E D C]
    end
  end
end
