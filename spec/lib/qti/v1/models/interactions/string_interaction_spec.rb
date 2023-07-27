describe Qti::V1::Models::Interactions::StringInteraction do
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

  context 'essay.xml' do
    let(:file_path) { File.join(fixtures_path, 'essay.xml') }
    let(:cardinality) { 'Single' }

    it 'returns the correct cardinality' do
      expect(loaded_class.send(:rcardinality)).to eq(cardinality)
    end

    it 'returns the correct settings' do
      expect(loaded_class.rce).to eq(true)
      expect(loaded_class.word_count).to eq(false)
      expect(loaded_class.spell_check).to eq(false)
      expect(loaded_class.word_limit_max).to be_nil
      expect(loaded_class.word_limit_min).to be_nil
    end
  end

  context 'essay.xml question with custom settings' do
    let(:file_path) { File.join(fixtures_path, 'essay_custom_settings.xml') }

    it 'returns the correct settings' do
      expect(loaded_class.rce).to eq(false)
      expect(loaded_class.word_count).to eq(true)
      expect(loaded_class.spell_check).to eq(true)
      expect(loaded_class.word_limit_max).to eq('500')
      expect(loaded_class.word_limit_min).to eq('140')
    end
  end
end
