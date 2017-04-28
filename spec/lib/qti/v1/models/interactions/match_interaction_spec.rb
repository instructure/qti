require 'spec_helper'

describe Qti::V1::Models::Interactions::MatchInteraction do
  let(:file) { File.join('spec', 'fixtures', 'items_1.2', 'matching.xml') }
  let(:assessment) { Qti::V1::Models::Assessment.from_path!(file) }
  let(:item) { assessment.assessment_items.first }
  subject { described_class.new(item) }

  it 'returns shuffle setting' do
    expect(subject.shuffled?).to eq false
  end

  it 'returns the answers' do
    expect(subject.answers.map(&:item_body)).to eq(
      ['Magnify up to about 400 times. Sometimes requires colored staining of cells.',
       "Uses a beam of electrons. Can provide details of cells' internal structure.",
       'A distractor answer.']
    )
  end

  describe '.matches' do
    it 'matches the item in file' do
      expect(described_class.matches(item)).to be_truthy
    end
  end

  describe '#scoring_data_structs' do
    it 'grabs scoring data value for matching questions' do
      expect(subject.scoring_data_structs.first.values).to eq(
        'question_1' => 'Magnify up to about 400 times. Sometimes requires colored staining of cells.',
        'question_2' => "Uses a beam of electrons. Can provide details of cells' internal structure."
      )
    end
  end

  describe '#questions' do
    it 'returns the questions' do
      expect(subject.questions).to eq(
        [{ id: 'question_1', question_body: 'Light Microscope' },
         { id: 'question_2', question_body: 'Electron Microscopes' }]
      )
    end
  end
end
