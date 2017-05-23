require 'spec_helper'

describe Qti::V2::Models::Interactions::OrderingInteraction do
  let(:file) { File.join('spec', 'fixtures', 'items_2.1', 'order.xml') }
  let(:item) { Qti::V2::Models::AssessmentItem.from_path!(file) }
  subject { described_class.new(item.doc) }

  describe '.matches' do
    it 'matches the item in file' do
      expect(described_class.matches(item.doc)).to be_truthy
    end
  end

  describe '#scoring_data_structs' do
    it 'grabs scoring data value for ordering questions' do
      expect(subject.scoring_data_structs.map(&:values)).to eq ['DriverC', 'DriverA', 'DriverB']
    end
  end
end
