describe Qti::V1::Models::Interactions::CategorizationInteraction do
  let(:xml_file_name) { 'categorization.xml' }
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:file_path) { File.join(fixtures_path, xml_file_name) }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:item) { assessment_item_refs.first }

  describe '.matches' do
    it 'matches the item in file' do
      expect(described_class.matches(item, test_object)).to be_truthy
    end
  end

  describe '#item_body' do
    let(:loaded_class) { described_class.new(item, test_object) }
    it 'returns correct item body' do
      expect(loaded_class.item_body).to eq '<p>Hello there</p>'
    end
  end

  describe '#categories' do
    let(:loaded_class) { described_class.new(item, test_object) }
    it 'returns correct categories' do
      expected_categories =
        {
          'df4fb8d7-8033-445a-b8be-171dd9b973ba' => { id: 'df4fb8d7-8033-445a-b8be-171dd9b973ba',
                                                      item_body: 'Category_A' },
          'eb2f823d-b857-4c06-9d5f-998d14ee8d58' => { id: 'eb2f823d-b857-4c06-9d5f-998d14ee8d58',
                                                      item_body: 'Category_B' }
        }
      expect(loaded_class.categories).to eq(expected_categories)
    end
  end

  describe '#distractors' do
    let(:loaded_class) { described_class.new(item, test_object) }
    it 'returns the correct distractors' do
      expected_distractors =
        { '19e37ce3-3a8b-4e26-ab61-9770e58af00e' => 'Distractor2',
          '3b8dcef8-c8c1-4827-85b0-6e381739adbf' => 'B1',
          '53a97aa7-d55c-402c-a061-f85d837c7c77' => 'A2',
          '5a67c627-cf85-4b70-922a-c7d1b7c720b8' => 'B2',
          '5d78f3f5-28c2-4e71-9c33-70c6b301e017' => 'Distractor1',
          '9432e8cb-1d3e-4d04-89b5-95185b7e557d' => 'A1' }
      expect(loaded_class.distractors).to eq(expected_distractors)
    end
  end

  describe '#scoring_data_structs' do
    let(:loaded_class) { described_class.new(item, test_object) }
    it 'returns the correct scoring data structs' do
      scoring_data_ids = %w[df4fb8d7-8033-445a-b8be-171dd9b973ba eb2f823d-b857-4c06-9d5f-998d14ee8d58]
      scoring_data_values = [
        %w[9432e8cb-1d3e-4d04-89b5-95185b7e557d 53a97aa7-d55c-402c-a061-f85d837c7c77],
        %w[3b8dcef8-c8c1-4827-85b0-6e381739adbf 5a67c627-cf85-4b70-922a-c7d1b7c720b8]
      ]
      expect(loaded_class.scoring_data_structs.map(&:id)).to eq(scoring_data_ids)
      expect(loaded_class.scoring_data_structs.map(&:values)).to eq(scoring_data_values)
    end
  end
end
