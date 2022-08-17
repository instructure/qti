describe Qti::V1::Models::Interactions::CanvasMultipleDropdownInteraction do
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

  shared_examples_for 'shuffled?' do
    it 'returns shuffle setting' do
      expect(loaded_class.shuffled?).to eq shuffle_value
    end
  end

  shared_examples_for 'answers' do
    it 'returns the answers' do
      expect(loaded_class.answers.count).to eq answer_count
      expect(loaded_class.answers).to eq(expected_answers)
    end
  end

  shared_examples_for 'stem_items' do
    it 'returns the stem_items' do
      expect(loaded_class.stem_items).to eq(expected_stem_items)
    end
  end

  shared_examples_for 'scoring_data_structs' do
    it 'returns the scoring_data_structs' do
      expect(loaded_class.scoring_data_structs.map(&:id)).to eq(scoring_data_ids)
      expect(loaded_class.scoring_data_structs.map(&:values)).to eq(scoring_data_values)
    end
  end

  context 'canvas_multiple_dropdowns.xml' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_dropdowns.xml') }
    let(:shuffle_value) { false }
    let(:answer_count) { 2 }
    let(:scoring_data_ids) { %w[response_color1 response_color2] }
    let(:scoring_data_values) do
      [
        { id: '6548', position: 2, item_body: 'red' },
        { id: '6951', position: 2, item_body: 'blue' }
      ]
    end
    let(:expected_stem_items) do
      [
        { id: 'stem_0', position: 1, type: 'text', value: '<div><p>Roses are ' },
        { id: 'stem_1', position: 2, type: 'blank', blank_id: 'response_color1', blank_name: 'red' },
        { id: 'stem_2', position: 3, type: 'text', value: ', violets are ' },
        { id: 'stem_3', position: 4, type: 'blank', blank_id: 'response_color2', blank_name: 'blue' },
        { id: 'stem_4', position: 5, type: 'text', value: '.</p></div>' }
      ]
    end
    let('expected_answers') do
      [
        {
          value: 'response_color1',
          entry_id: '6548',
          blank_text: 'red',
          action: 'Add',
          point_value: '50.00'
        },
        {
          value: 'response_color2',
          entry_id: '6951',
          blank_text: 'blue',
          action: 'Add',
          point_value: '50.00'
        }
      ]
    end

    include_examples 'shuffled?'
    include_examples 'answers'
    include_examples 'stem_items'
    include_examples 'scoring_data_structs'
  end
end
