describe Qti::V1::Models::Interactions::OrderingInteraction do
  let(:file) { File.join('spec', 'fixtures', 'items_1.2', 'ordering.xml') }
  let(:assessment) { Qti::V1::Models::Assessment.from_path!(file) }
  let(:item) { assessment.assessment_items.first }
  subject { described_class.new(item, assessment) }

  describe '.matches' do
    it 'matches the item in file' do
      expect(described_class.matches(item, assessment)).to be_truthy
    end
  end

  describe '.top_label' do
    context 'when the item does not have a top label' do
      it 'returns nil' do
        expect(subject.top_label).to be_nil
      end
    end

    context 'when the item has a top label' do
      let(:file) { File.join('spec', 'fixtures', 'items_1.2', 'ordering_with_labels.xml') }

      it 'returns the right bottom label' do
        expect(subject.top_label).to eq('This is the top label')
      end
    end
  end

  describe '.bottom label' do
    context 'when the item does not have a bottom label' do
      it 'returns the right bottom label' do
        expect(subject.bottom_label).to be_nil
      end
    end

    context 'when the item has a bottom label' do
      let(:file) { File.join('spec', 'fixtures', 'items_1.2', 'ordering_with_labels.xml') }

      it 'returns the right bottom label' do
        expect(subject.bottom_label).to eq('This is the bottom label')
      end
    end
  end

  describe '.display_answers_paragraph' do
    context 'when the ordering item orientation is set to "Row"' do
      let(:file) { File.join('spec', 'fixtures', 'items_1.2', 'ordering.row.xml') }

      it 'returns true' do
        expect(subject.display_answers_paragraph).to eq(true)
      end
    end

    context 'when the ordering item orientation is not set to "Row"' do
      it 'returns false' do
        expect(subject.display_answers_paragraph).to eq(false)
      end
    end
  end

  describe '#scoring_data_structs' do
    it 'grabs scoring data value for ordering questions' do
      assessment_item = described_class.new(assessment.assessment_items.first, assessment)
      expect(assessment_item.scoring_data_structs.map(&:values)).to eq %w[A B E D C]
    end
  end
end
