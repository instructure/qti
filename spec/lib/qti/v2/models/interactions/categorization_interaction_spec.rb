describe Qti::V2::Models::Interactions::CategorizationInteraction do
  let(:assessment_item) { Qti::V2::Models::AssessmentItem.from_path! 'spec/fixtures/items_2.1/categorization.xml' }
  subject { assessment_item.interaction_model }

  it { is_expected.to be_an_instance_of(described_class) }

  it 'returns shuffle setting' do
    expect(subject.shuffled?).to eq true
  end

  describe '#scoring_data_structs' do
    it 'returns the scoring data for categorization questions' do
      expected_scoring_data_structs = [
        Qti::V2::Models::ScoringData.new("A Midsummer-Night's Dream", 'directedPair', id: 'M', questions_ids: %w[D L]),
        Qti::V2::Models::ScoringData.new('Romeo and Juliet', 'directedPair', id: 'R', questions_ids: ['C']),
        Qti::V2::Models::ScoringData.new('The Tempest', 'directedPair', id: 'T', questions_ids: ['P'])
      ]
      expect(subject.scoring_data_structs).to eq expected_scoring_data_structs
    end
  end
end
