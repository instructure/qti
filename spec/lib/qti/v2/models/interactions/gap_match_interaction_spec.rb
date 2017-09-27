require 'spec_helper'

describe Qti::V2::Models::Interactions::GapMatchInteraction do
  context 'gap_match.xml' do
    let(:item) { double(package_root: 'dummy', path: 'dummy/blah') }
    let(:io) { File.read(File.join('spec', 'fixtures', 'items_2.1', 'gap_match.xml')) }
    let(:node) { Nokogiri::XML(io) }
    let(:loaded_class) { described_class.new(node, item) }

    let(:expected_stem_items) do
      [
        { type: 'text',
          value: "Identify the missing words in this famous quote from Shakespeare's Richard III.",
          id: 'stem_0', position: 1 },
        { type: 'text', value: 'Now is the ', id: 'stem_1', position: 2 },
        { type: 'blank', blank_id: 'G1', id: 'stem_2', position: 3 },
        { type: 'text', value: ' of our discontent', id: 'stem_3', position: 4 },
        { type: 'text', value: ' ', id: 'stem_4', position: 5 },
        { type: 'text', value: ' Made glorious ', id: 'stem_5', position: 6 },
        { type: 'blank', blank_id: 'G2', id: 'stem_6', position: 7 },
        { type: 'text', value: ' by this sun of York;', id: 'stem_7', position: 8 },
        { type: 'text', value: ' ', id: 'stem_8', position: 9 },
        { type: 'text', value: " And all the clouds that lour'd\n          upon our house",
          id: 'stem_9', position: 10 },
        { type: 'text', value: ' ', id: 'stem_10', position: 11 },
        { type: 'text', value: ' In the deep bosom of the ocean buried.',
          id: 'stem_11', position: 12 }
      ]
    end

    let(:scoring_data_ids) { %w[G1 G2] }
    let(:scoring_data_values) { %w[winter summer] }

    it 'returns shuffle setting' do
      expect(loaded_class.shuffled?).to eq false
    end

    it 'returns the blanks' do
      expect(loaded_class.blanks).to eq [{ id: 'W' }, { id: 'Sp' }, { id: 'Su' }, { id: 'A' }]
    end

    it 'returns the stem_items' do
      expect(loaded_class.stem_items).to eq(expected_stem_items)
    end

    it 'returns the answers' do
      expect(loaded_class.answers.count).to eq 2
      expect(loaded_class.answers.first).to be_an_instance_of(Qti::V2::Models::Choices::GapMatchChoice)
    end

    it 'returns the choices' do
      expect(loaded_class.choices.count).to eq 4
    end

    it 'returns the scoring_data_structs' do
      expect(loaded_class.scoring_data_structs.map(&:id)).to eq(scoring_data_ids)
      expect(loaded_class.scoring_data_structs.map(&:values)).to eq(scoring_data_values)
    end
  end
end
