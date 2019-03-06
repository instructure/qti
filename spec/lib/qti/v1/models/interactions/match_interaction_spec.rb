require 'spec_helper'

describe Qti::V1::Models::Interactions::MatchInteraction do
  let(:path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:assessment) { Qti::V1::Models::Assessment.from_path!(file) }
  let(:item) { assessment.assessment_items.first }
  let(:subject) { described_class.new(item, assessment) }

  shared_examples_for 'common features' do
    describe '.matches' do
      it 'matches the item in file' do
        expect(described_class.matches(item, assessment)).to be_truthy
      end
    end

    it 'returns shuffle setting' do
      expect(subject.shuffled?).to eq false
    end
  end

  shared_examples_for 'questions and answers' do
    it 'returns the answers' do
      expect(subject.answers.map(&:item_body)).to eq(expected_answers)
    end

    it 'returns the questions' do
      expect(subject.questions).to eq(expected_questions)
    end

    it 'contaons distractors' do
      expect(subject.distractors).to eq(expected_distractors)
    end
  end

  shared_examples_for '#scoring_data_structs' do
    it 'grabs scoring data value for matching questions' do
      expect(subject.scoring_data_structs.first.values).to eq(expected_scoring_data)
    end
  end

  context 'matching.xml' do
    let(:file) { File.join(path, 'matching.xml') }
    let(:expected_answers) do
      [
        'Magnify up to about 400 times. Sometimes requires colored staining of cells.',
        "Uses a beam of electrons. Can provide details of cells' internal structure.",
        'A distractor answer.'
      ]
    end
    let(:expected_questions) do
      [
        { id: 'question_1', itemBody: 'Light Microscope' },
        { id: 'question_2', itemBody: 'Electron Microscopes' }
      ]
    end
    let(:expected_scoring_data) do
      {
        'question_1' => 'Magnify up to about 400 times. Sometimes requires colored staining of cells.',
        'question_2' => "Uses a beam of electrons. Can provide details of cells' internal structure."
      }
    end
    let(:expected_distractors) { ['A distractor answer.'] }

    include_examples('common features')
    include_examples('questions and answers')
    include_examples('#scoring_data_structs')
  end

  context 'matching_feedback.xml' do
    let(:file) { File.join(path, 'matching_feedback.xml') }
    let(:expected_answers) { '1,2,,C,D,E,F,3,4,5,6'.split(',') }
    let(:expected_questions) do
      [
        { id: 'response_6831', itemBody: 'A' },
        { id: 'response_6259', itemBody: 'B' },
        { id: 'response_743', itemBody: '' },
        { id: 'response_1943', itemBody: '' }
      ]
    end
    let(:expected_scoring_data) do
      {
        'response_6831' => '1',
        'response_6259' => '2',
        'response_743' => '',
        'response_1943' => ''
      }
    end
    let(:expected_distractors) { %w[C D E F 3 4 5 6] }

    include_examples('common features')
    include_examples('questions and answers')
    include_examples('#scoring_data_structs')
  end
end
