require 'spec_helper'

describe Qti::V1::Models::Interactions::UploadInteraction do
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

  context 'upload.xml' do
    let(:file_path) { File.join(fixtures_path, 'upload.xml') }
    let(:cardinality) { 'Single' }

    it 'returns loads the correct cardinality' do
      expect(loaded_class.send(:rcardinality)).to eq(cardinality)
    end

    context '#item_body' do
      let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
      it 'returns right title' do
        expect(loaded_class.item_body).to eq 'Upload a file that is a CSV'
      end
    end

    describe '#scoring_data_structs' do
      it 'grabs scoring data value for matching questions' do
        expect(loaded_class.scoring_data_structs).to eq(
          value: ''
        )
      end
    end
  end
end
