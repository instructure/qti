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
        { id: 'question_1', item_body: 'Light Microscope' },
        { id: 'question_2', item_body: 'Electron Microscopes' }
      ]
    end
    let(:expected_scoring_data) do
      {
        'question_1' => 'Magnify up to about 400 times. Sometimes requires colored staining of cells.',
        'question_2' => "Uses a beam of electrons. Can provide details of cells' internal structure."
      }
    end
    let(:expected_distractors) { ['A distractor answer.'] }

    it 'has the correct scoring algorithm' do
      expect(subject.scoring_algorithm).to eq 'AllOrNothing'
    end

    include_examples('common features')
    include_examples('questions and answers')
    include_examples('#scoring_data_structs')
  end

  context 'matching_feedback.xml' do
    let(:file) { File.join(path, 'matching_feedback.xml') }
    let(:expected_answers) { '1,2,,C,D,E,F,3,4,5,6'.split(',') }
    let(:expected_questions) do
      [
        { id: 'response_6831', item_body: 'A' },
        { id: 'response_6259', item_body: 'B' },
        { id: 'response_743', item_body: '' },
        { id: 'response_1943', item_body: '' }
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

    it 'does not have any scoring algorithm' do
      expect(subject.scoring_algorithm).to eq nil
    end

    describe '#answer_feedback' do
      it 'returns one entry per commented left hand item, keyed on its response id' do
        expect(subject.answer_feedback).to eq(
          [
            { response_id: 'response_6831', response_value: '6753', negated: true,
              texttype: 'text/html', feedback: '<p>A:1</p>' },
            { response_id: 'response_6259', response_value: '7138', negated: true,
              texttype: 'text/html', feedback: '<p>B:2</p>' }
          ]
        )
      end

      it 'marks the entries as negated, since Classic shows them on a wrong pairing' do
        expect(subject.answer_feedback.map { |fb| fb[:negated] }).to all(be true)
      end

      it 'keys every entry on a question that exists' do
        expect(subject.answer_feedback.map { |fb| fb[:response_id] })
          .to all(be_in(subject.questions.map { |q| q[:id] }))
      end

      it 'skips the left hand items without a comment' do
        expect(subject.answer_feedback.map { |fb| fb[:response_id] })
          .not_to include('response_743', 'response_1943')
      end

      it 'ignores the item level feedback' do
        expect(subject.answer_feedback.map { |fb| fb[:feedback] })
          .not_to include('<p>Neutral</p>', '<p>Correct</p>', '<p>Incorrect</p>')
      end
    end
  end

  context 'matching.xml without answer feedback' do
    let(:file) { File.join(path, 'matching.xml') }

    it 'returns nil' do
      expect(subject.answer_feedback).to be_nil
    end
  end
end
