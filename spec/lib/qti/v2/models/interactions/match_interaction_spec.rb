describe Qti::V2::Models::Interactions::MatchInteraction do
  context 'assessmentItem is implemented with <associateInteraction>' do
    let(:assessment_item) { Qti::V2::Models::AssessmentItem.from_path! 'spec/fixtures/items_2.1/match.xml' }
    subject { assessment_item.interaction_model }

    it { is_expected.to be_an_instance_of(described_class) }

    it 'returns shuffle setting' do
      expect(subject.shuffled?).to eq true
    end

    describe '#scoring_data_structs' do
      it 'grabs scoring data value for matching questions' do
        expect(subject.scoring_data_structs).to eq [
          Qti::V2::Models::ScoringData.new('Prospero', 'Pair', id: 'P', question_id: 'A'),
          Qti::V2::Models::ScoringData.new('Montague', 'Pair', id: 'M', question_id: 'C'),
          Qti::V2::Models::ScoringData.new('Lysander', 'Pair', id: 'L', question_id: 'D')
        ]
      end
    end

    describe '#answers' do
      it 'returns the correct_answers' do
        expect(subject.answers.map(&:item_body)).to eq(%w[Lysander Montague Prospero])
      end
    end

    describe '#questions' do
      it 'returns the questions' do
        expect(subject.questions).to eq(
          [{ id: 'A', itemBody: 'Antonio' },
           { id: 'C', itemBody: 'Capulet' },
           { id: 'D', itemBody: 'Demetrius' }]
        )
      end
    end
  end

  context 'assessmentItem is implemented with <matchInteraction>' do
    let(:assessment_item) { Qti::V2::Models::AssessmentItem.from_path! 'spec/fixtures/items_2.1/match2.xml' }
    subject { assessment_item.interaction_model }

    it { is_expected.to be_an_instance_of(described_class) }

    it 'returns shuffle setting' do
      expect(subject.shuffled?).to eq true
    end

    describe '#scoring_data_structs' do
      it 'grabs scoring data value for matching questions' do
        expect(subject.scoring_data_structs).to eq [
          Qti::V2::Models::ScoringData.new('Dresden', 'Pair', id: 'Match2675678', question_id: 'Match28433682'),
          Qti::V2::Models::ScoringData.new('Leipzig', 'Pair', id: 'Match9372581', question_id: 'Match7191791'),
          Qti::V2::Models::ScoringData.new('Halle', 'Pair', id: 'Match22744006', question_id: 'Match20473010'),
          Qti::V2::Models::ScoringData.new('Bautzen', 'Pair', id: 'Match17943221', question_id: 'Match6429655')
        ]
      end
    end

    describe '#answers' do
      it 'returns the correct_answers' do
        expect(subject.answers.map(&:item_body)).to eq %w[Dresden Leipzig Halle Bautzen]
      end
    end

    describe '#questions' do
      it 'returns the questions' do
        expect(subject.questions).to eq(
          [{ id: 'Match28433682', itemBody: 'Weißeritz' },
           { id: 'Match7191791', itemBody: 'Mulde' },
           { id: 'Match20473010', itemBody: 'Saale' },
           { id: 'Match6429655', itemBody: 'Spree' }]
        )
      end
    end
  end
end
