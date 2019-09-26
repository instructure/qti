describe Qti::V1::Models::Choices::FillBlankChoice do
  context 'fib.xml' do
    let(:fixtures_path) { File.join('spec', 'fixtures') }
    let(:file_path) { File.join(fixtures_path, 'items_1.2', 'fib.xml') }
    let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
    let(:nodes) { test_object.assessment_items }
    let(:choices) { nodes.map { |node| described_class.new(node, test_object) } }

    it 'returns the right identifier' do
      expect(choices.map(&:identifier)).to eq %w[FIB_STR]
    end

    it 'returns the item body text' do
      expect(choices.map(&:item_body).map(&:empty?).any?).to eq false
    end

    it 'removes inline feedback elements from item_body' do
      expect(choices.map(&:item_body).map { |text| text.include? 'correct' }.any?).to eq false
    end
  end
end
