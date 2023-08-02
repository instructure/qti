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

  context 'nq_multiple_fib_answer_types.xml' do
    let(:fixtures_path) { File.join('spec', 'fixtures') }
    let(:file_path) { File.join(fixtures_path, 'items_1.2', 'nq_multiple_fib_answer_types.xml') }
    let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
    let(:nodes) { test_object.assessment_items }
    let(:dropdown_answer) { nodes.xpath('.//xmlns:response_lid').first }
    let(:dropdown_choices) { dropdown_answer.xpath('.//xmlns:response_label') }
    let(:choices) { dropdown_choices.map { |answer| described_class.new(answer, test_object) } }

    it 'returns the right positions' do
      expect(choices.map(&:position)).to eq %w[1 2 3]
    end
  end
end
