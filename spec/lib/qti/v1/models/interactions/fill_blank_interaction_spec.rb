require 'spec_helper'

describe Qti::V1::Models::Interactions::FillBlankInteraction do
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

  shared_examples_for 'shuffled?' do
    it 'returns shuffle setting' do
      expect(loaded_class.shuffled?).to eq shuffle_value
    end
  end

  shared_examples_for 'blanks' do
    it 'returns the blanks' do
      expect(loaded_class.blanks).to eq [{ id: 'FIB01' }, { id: 'FIB02' }, { id: 'FIB03' }]
    end
  end

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
      expect(loaded_class.scoring_data_structs.map(&:case)).to eq(scoring_data_case)
    end
  end

  shared_examples_for 'stem_items' do
    it 'returns the stem_items' do
      expect(loaded_class.stem_items).to eq(expected_stem_items)
    end
  end

  context 'fib_str.xml' do
    let(:file_path) { File.join(fixtures_path, 'fib_str.xml') }
    let(:shuffle_value) { false }
    let(:scoring_data_ids) { %w[FIB01 FIB02 FIB03] }
    let(:scoring_data_values) { %w[Winter Summer York] }
    let(:scoring_data_case) { %w[Yes Yes Yes] }
    let(:answer_count) { 3 }
    let(:expected_stem_items) do
      [
        { id: 'stem_0', position: 1, type: 'text', value: 'Fill-in-the blanks in this text from Richard III: ' },
        { id: 'stem_1', position: 2, type: 'text', value: 'Now is the ' },
        { id: 'stem_2', position: 3, type: 'blank', blank_id: 'FIB01' },
        { id: 'stem_3', position: 4, type: 'text', value: ' of our discontent made glorious ' },
        { id: 'stem_4', position: 5, type: 'blank', blank_id: 'FIB02' },
        { id: 'stem_5', position: 6, type: 'text', value: ' by these sons of ' },
        { id: 'stem_6', position: 7, type: 'blank', blank_id: 'FIB03' }
      ]
    end

    include_examples 'shuffled?'
    include_examples 'answers'
    include_examples 'scoring_data_structs'
    include_examples 'stem_items'
  end

  describe '#scoring_data_structs' do
    let(:nodexml) { double }
    let(:test_object) { double(package_root: 'dummy', path: 'dummy/blah') }
    subject { described_class.new(nodexml, test_object) }

    it "returns 'no' as case default value" do
      allow(nodexml).to receive(:at_xpath)
      node = double(content: 'content', attributes: { 'respident' => double(value: 'a') })
      allow(subject).to receive(:answer_nodes).and_return([node])
      expect(subject.scoring_data_structs.first.case).to eq 'no'
    end
  end
end
