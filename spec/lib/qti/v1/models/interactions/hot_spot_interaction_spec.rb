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
      expect(loaded_class.shape_type).to eq 'rectangle'
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

  describe '#scoring_data_structs' do
    context 'with a single hotspot' do
      let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

      it 'returns scoring data with a single hotspot' do
        scoring_data = loaded_class.scoring_data_structs
        expect(scoring_data.size).to eq(1)
        expect(scoring_data.first.values[:type]).to eq('rectangle')
        expect(scoring_data.first.values[:coordinates]).to eq([{ x: 0.372, y: 0.1376 }, { x: 0.616, y: 0.4256 }])
      end
    end

    context 'with multiple hotspots' do
      let(:loaded_class) { described_class.new(assessment_item_refs[3], test_object) }

      it 'returns scoring data with multiple hotspots' do
        scoring_data = loaded_class.scoring_data_structs
        expect(scoring_data.size).to eq(3)

        expect(scoring_data[0].values[:type]).to eq('rectangle')
        expect(scoring_data[0].values[:coordinates]).to eq([{ x: 0.1, y: 0.2 }, { x: 0.3, y: 0.4 }])

        expect(scoring_data[1].values[:type]).to eq('ellipse')
        expect(scoring_data[1].values[:coordinates]).to eq([{ x: 0.5, y: 0.6 }, { x: 0.7, y: 0.8 }])

        expect(scoring_data[2].values[:type]).to eq('bounded')
        expect(scoring_data[2].values[:coordinates]).to eq([{ x: 0.9, y: 0.1 }, { x: 0.2, y: 0.3 }])
      end
    end
  end
end
