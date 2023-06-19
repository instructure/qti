describe Qti::V1::Models::Interactions::HotSpotInteraction do
  let(:xml_file_name) { 'hot_spot.xml' }
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:file_path) { File.join(fixtures_path, xml_file_name) }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }

  describe '.matches' do
    it 'matches the item in file' do
      expect(described_class.matches(test_object.assessment_items, test_object)).to be_truthy
    end
  end

  describe '#item_body' do
    let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
    it 'returns correct item body' do
      expect(loaded_class.item_body).to eq '<p>point something on the image</p>'
    end
  end

  describe '#image_url' do
    let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
    it 'returns correct image url' do
      expect(loaded_class.image_url).to eq '$IMS-CC-FILEBASE$/Uploaded Media/someuuid'
    end
  end

  describe '#shape_type' do
    let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
    it 'returns correct shape type' do
      expect(loaded_class.shape_type).to eq 'square'
    end
  end

  describe '#coordinates' do
    let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
    it 'returns correct coordinates' do
      expect(loaded_class.coordinates).to eq [{ "x": 0.372, "y": 0.1376 }, { "x": 0.616, "y": 0.4256 }]
    end

    context 'when the response label does not have an even amount of numbers' do
      let(:loaded_class) { described_class.new(assessment_item_refs[1], test_object) }

      it 'returns an empty array' do
        expect(loaded_class.coordinates).to eq []
      end
    end

    context 'when the response label is empty' do
      let(:loaded_class) { described_class.new(assessment_item_refs[2], test_object) }

      it 'returns an empty array' do
        expect(loaded_class.coordinates).to eq []
      end
    end
  end
end
