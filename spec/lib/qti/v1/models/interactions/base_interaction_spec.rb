describe Qti::V1::Models::Interactions::BaseInteraction do
  let(:doc) do
    <<~XML
      <?xml version="1.0" encoding="ISO-8859-1"?>
      <questestinterop xmlns="http://www.imsglobal.org/xsd/ims_qtiasiv1p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd">
        <response_lid ident="QUE_1008_RL" rtiming="No">
        </response_lid>
      </questestinterop>
    XML
  end

  let(:node) { Nokogiri.XML(doc, &:noblanks) }
  let(:assessment) { double(path: 'dummy/blah', package_root: 'dummy') }

  it 'returns "Single" rcardinality by default' do
    interaction = described_class.new(node, assessment)
    expect(interaction.rcardinality).to eq 'Single'
  end

  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

  shared_examples_for 'item_level_feedback' do
    it 'returns the correct item-level feedback' do
      expect(loaded_class.canvas_item_feedback[:neutral]).to eq(general_fb)
      expect(loaded_class.canvas_item_feedback[:correct]).to eq(correct_fb)
      expect(loaded_class.canvas_item_feedback[:incorrect]).to eq(incorrect_fb)
    end
  end

  shared_examples_for 'answer_feedback' do
    it 'returns the correct answer feedback' do
      expect(loaded_class.answer_feedback).to eq(answer_fb)
    end
  end

  context 'canvas_multiple_dropdown.xml' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_dropdown.xml') }
    let(:general_fb) do
      "<p>Roses come in many colors, violets probably do too.</p>\n<p>Never the less, " \
      'the correct answers were <strong>red</strong> and <strong>blue</strong>.</p>'
    end
    let(:correct_fb) { '<p>Completing the poem, is left to you.</p>' }
    let(:incorrect_fb) { '<p>Those aren\'t colors, you meant <strong>red</strong> and <strong>blue</strong>.</p>' }

    let(:answer_fb) do
      [
        { response_id: 'response_color1', response_value: '6548',
          texttype: 'text/html', feedback: '<p>Yes! <strong>Red</strong>.</p>' },
        { response_id: 'response_color1', response_value: '5550',
          texttype: 'text/html', feedback: "<p>I'm pretty sure you meant <strong>red.</strong></p>" },
        { response_id: 'response_color2', response_value: '6951',
          texttype: 'text/html', feedback: '<p>Yes, <strong>blue</strong>!</p>' },
        { response_id: 'response_color2', response_value: '4500',
          texttype: 'text/html', feedback: '<p>Did you also chose plaid? You wanted to <strong>blue</strong>.</p>' }
      ]
    end

    include_examples('item_level_feedback')
    include_examples('answer_feedback')
  end

  context 'canvas_multiple_fib.xml' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_fib.xml') }
    let(:general_fb) { nil }
    let(:correct_fb) { nil }
    let(:incorrect_fb) { nil }
    let(:answer_fb) { nil }

    include_examples('item_level_feedback')
    include_examples('answer_feedback')
  end

  context 'mc_feedback.xml' do
    let(:file_path) { File.join(fixtures_path, 'mc_feedback.xml') }
    let(:general_fb) { '<p>General Feedback</p>' }
    let(:correct_fb) { '<p>General Correct Feedback</p>' }
    let(:incorrect_fb) { '<p>General Incorrect Feedback</p>' }
    let(:answer_fb) do
      [
        { response_id: 'response1', response_value: '5706',
          texttype: 'text/html', feedback: '<p>Answer A Feedback</p>' },
        { response_id: 'response1', response_value: '2408',
          texttype: 'text/html', feedback: '<p>Answer B Feedback</p>' },
        { response_id: 'response1', response_value: '621',
          texttype: 'text/html', feedback: '<p>Answer C Feedback</p>' },
        { response_id: 'response1', response_value: '7011',
          texttype: 'text/html', feedback: '<p>Answer D Feedback</p>' }
      ]
    end

    include_examples('item_level_feedback')
    include_examples('answer_feedback')
  end

  context 'nq_multiple_fib_scoring_algorithms.xml' do
    let(:file_path) { File.join(fixtures_path, 'nq_multiple_fib_scoring_algorithms.xml') }

    it 'correctly finds new quizzes QTI' do
      expect(Qti::V1::Models::Interactions::BaseInteraction.new_quizzes_fib?(assessment_item_refs.first)).to eq true
    end
  end

  context 'canvas_multiple_fib.xml' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_fib.xml') }

    it 'correctly does not find new quizzes QTI' do
      expect(Qti::V1::Models::Interactions::BaseInteraction.new_quizzes_fib?(assessment_item_refs.first)).to eq false
    end
  end

  # The respcondition lookup in #answer_feedback is shared by every v1
  # interaction, so relaxing it to reach matching's negated varequal has to
  # leave the other types untouched. This fixture carries one question of each
  # Canvas type, all of them fully commented.
  context 'all_canvas_simple_1.2.xml' do
    let(:file_path) { File.join('spec', 'fixtures', 'all_canvas_simple_1.2.xml') }

    def answer_feedback_for(index)
      described_class.new(assessment_item_refs[index], test_object).answer_feedback&.map do |fb|
        [fb[:response_id], fb[:response_value], fb[:negated], fb[:feedback]]
      end
    end

    it 'extracts multiple choice feedback per chosen answer' do
      expect(answer_feedback_for(0)).to eq(
        [
          ['response1', '2799', nil, '<p>Answer feedback for C, correct</p>'],
          ['response1', '9607', nil, '<p>Answer feedback for A, incorrect</p>'],
          ['response1', '599', nil, '<p>Answer feedback for B, incorrect</p>'],
          ['response1', '5711', nil, '<p>Answer feedback for D, incorrect</p>']
        ]
      )
    end

    it 'extracts true/false feedback per chosen answer' do
      expect(answer_feedback_for(1)).to eq(
        [
          ['response1', '919', nil, '<p>Answer Feedback, True, Correct</p>'],
          ['response1', '2680', nil, '<p>Answer Feedback, False, Incorrect</p>']
        ]
      )
    end

    it 'extracts short answer feedback per chosen answer' do
      expect(answer_feedback_for(2)).to eq(
        [
          ['response1', 'Blank', nil, '<p>Answer Feedback, Correct, Blank</p>'],
          ['response1', 'blank', nil, '<p>Answer Feedback, Correct, blank</p>']
        ]
      )
    end

    it 'extracts fill in multiple blanks feedback per blank and chosen answer' do
      expect(answer_feedback_for(3)).to eq(
        [
          ['response_Multiple', '832', nil, '<p>Answer Feedback, correct, Multiple</p>'],
          ['response_Multiple', '2173', nil, '<p>Answer Feedback, correct, multiple</p>'],
          ['response_Blanks', '9226', nil, '<p>Answer Feedback, correct, Blanks</p>'],
          ['response_Blanks', '1700', nil, '<p>Answer Feedback, correct, blanks</p>']
        ]
      )
    end

    it 'extracts multiple answers feedback per chosen answer' do
      expect(answer_feedback_for(4)).to eq(
        [
          ['response1', '4094', nil, '<p>Answer Feedback, correct, A</p>'],
          ['response1', '8128', nil, '<p>Answer Feedback, correct, B</p>'],
          ['response1', '1582', nil, '<p>Answer Feedback, correct, C</p>'],
          ['response1', '7498', nil, '<p>Answer Feedback, incorrect, D</p>'],
          ['response1', '141', nil, '<p>Answer Feedback, incorrect, E</p>'],
          ['response1', '3202', nil, '<p>Answer Feedback, incorrect, F</p>']
        ]
      )
    end

    it 'extracts multiple dropdowns feedback per chosen answer' do
      expect(answer_feedback_for(5)).to eq(
        [
          ['response_C', '520', nil, '<p>Answer Feedback, correct, C</p>'],
          ['response_C', '9701', nil, '<p>Answer Feedback, incorrect, D</p>']
        ]
      )
    end

    it 'extracts matching feedback per left hand item, marked as negated' do
      expect(answer_feedback_for(6)).to eq(
        [
          ['response_2030', '6823', true, '<p>Answer Feedback, A:1 Chosen</p>'],
          ['response_1293', '4469', true, '<p>Answer Feedback, B:2 Chosen</p>']
        ]
      )
    end

    it 'returns nil for the types that carry no answer level feedback' do
      expect(answer_feedback_for(8)).to be_nil
      expect(answer_feedback_for(9)).to be_nil
    end

    # The flag is additive: an entry that is not negated keeps exactly the keys
    # it had before matching was supported, so a consumer pinned to an older
    # gem sees no change.
    it 'only adds the negated key to the negated entries' do
      keys_by_item = (0..7).map do |index|
        entries = described_class.new(assessment_item_refs[index], test_object).answer_feedback || []
        entries.map(&:keys).uniq
      end
      expect(keys_by_item).to eq(
        [
          [%i[response_id response_value texttype feedback]],
          [%i[response_id response_value texttype feedback]],
          [%i[response_id response_value texttype feedback]],
          [%i[response_id response_value texttype feedback]],
          [%i[response_id response_value texttype feedback]],
          [%i[response_id response_value texttype feedback]],
          [%i[response_id response_value texttype feedback negated]],
          [%i[response_id response_value texttype feedback]]
        ]
      )
    end
  end

  # Question 4 has no question_type metadata and more than one response_lid, so
  # it dispatches to MatchInteraction while actually being fill in multiple
  # blanks -- and its feedback is on the chosen answer, not a wrong pairing.
  # Deriving negated per entry rather than per question type is what keeps this
  # one, and third party packages like it, correct.
  context 'interaction_checks_1.2.xml' do
    let(:file_path) { File.join('spec', 'fixtures', 'interaction_checks_1.2.xml') }

    it 'does not mark a non-negated question as negated, whatever it dispatches to' do
      item = assessment_item_refs[3]
      expect(Qti::V1::Models::AssessmentItem.new(item).interaction_model)
        .to be_a(Qti::V1::Models::Interactions::MatchInteraction)
      expect(described_class.new(item, test_object).answer_feedback.map { |fb| fb[:negated] })
        .to all(be_nil)
    end

    it 'still marks the genuine matching question as negated' do
      expect(described_class.new(assessment_item_refs[6], test_object).answer_feedback.map { |fb| fb[:negated] })
        .to all(be true)
    end
  end

  # NumericInteraction overrides #answer_feedback entirely (it pairs answers by
  # setvar SCORE, not by varequal), so it never reaches the negated flag. Its
  # entries are keyed on response_index and carry no negated key at all, which
  # reads the same as not negated.
  context 'numeric_answer_feedback.xml' do
    let(:file_path) { File.join(fixtures_path, 'numeric_answer_feedback.xml') }

    it 'does not report negated for numeric, which pairs answers differently' do
      entries = Qti::V1::Models::AssessmentItem.new(assessment_item_refs.first).answer_feedback
      expect(entries.map(&:keys).uniq).to eq([%i[response_index texttype feedback]])
      expect(entries.map { |fb| fb[:negated] }).to all(be_nil)
    end
  end

  # Ordering emits one respcondition holding a varequal per position, with a
  # single comment for the whole correct sequence. It has always been reported
  # through the first varequal and no spec covered it, so the relaxed xpath
  # could have changed it unnoticed.
  context 'ordering.xml' do
    let(:file_path) { File.join(fixtures_path, 'ordering.xml') }

    it 'keeps reporting the comment on the correct sequence through its first position' do
      expect(loaded_class.answer_feedback).to eq(
        [{ response_id: 'OB01', response_value: 'A',
           texttype: nil, feedback: 'Yes, the correct order.' }]
      )
    end
  end

  # Codifies the corpus wide check behind the xpath relaxation: matching is the
  # only shape in the whole fixture corpus that yields a negated entry. Guards
  # against a future xpath change quietly pulling in another type.
  context 'the whole fixture corpus' do
    it 'only ever reports negated entries for matching questions' do
      negated = Dir.glob(File.join('spec', 'fixtures', '**', '*.xml')).sort.filter_map do |path|
        assessment = begin
          Qti::V1::Models::Assessment.from_path!(path)
        rescue StandardError
          next
        end
        items = assessment.assessment_items
        next if items.nil?

        found = items.each_with_index.select do |item, _index|
          entries = begin
            described_class.new(item, assessment).answer_feedback
          rescue StandardError
            nil
          end
          entries&.any? { |fb| fb[:negated] }
        end
        next if found.empty?

        [path.sub("spec#{File::SEPARATOR}fixtures#{File::SEPARATOR}", ''), found.map(&:last)]
      end

      expect(negated.to_h).to eq(
        'all_canvas_simple_1.2.xml' => [6],
        'interaction_checks_1.2.xml' => [6],
        "items_1.2#{File::SEPARATOR}matching_feedback.xml" => [0]
      )
    end
  end

  # Shapes the relaxed xpath newly reaches. None occur in a Canvas export, but
  # third party QTI 1.2 imports through the same code path.
  context 'unusual respcondition shapes' do
    let(:assessment) { double(path: 'dummy/blah', package_root: 'dummy') }

    def interaction_for(conditionvar)
      item = <<~XML
        <questestinterop xmlns="http://www.imsglobal.org/xsd/ims_qtiasiv1p2">
          <item ident="i1" title="Question">
            <resprocessing>
              <respcondition>
                <conditionvar>#{conditionvar}</conditionvar>
                <displayfeedback feedbacktype="Response" linkrefid="99_fb"/>
              </respcondition>
            </resprocessing>
            <itemfeedback ident="99_fb">
              <flow_mat>
                <material><mattext texttype="text/html">&lt;p&gt;Comment&lt;/p&gt;</mattext></material>
              </flow_mat>
            </itemfeedback>
          </item>
        </questestinterop>
      XML
      described_class.new(Nokogiri.XML(item, &:noblanks).at_xpath('//xmlns:item'), assessment)
    end

    # A compound condition is reported through its first answer only. That is
    # pre-existing behaviour -- ordering questions comment a whole correct
    # sequence this way -- so it is pinned here rather than changed, and the
    # negated flag follows the same first varequal.
    it 'reports a compound condition through its first answer' do
      interaction = interaction_for(
        '<and><varequal respident="response1">111</varequal>' \
        '<not><varequal respident="response1">222</varequal></not></and>'
      )
      expect(interaction.answer_feedback).to eq(
        [{ response_id: 'response1', response_value: '111',
           texttype: 'text/html', feedback: '<p>Comment</p>' }]
      )
    end

    it 'ignores a varequal without a respident when picking the answer' do
      interaction = interaction_for(
        '<or><varequal>raw</varequal><varequal respident="response1">111</varequal></or>'
      )
      expect(interaction.answer_feedback).to eq(
        [{ response_id: 'response1', response_value: '111',
           texttype: 'text/html', feedback: '<p>Comment</p>' }]
      )
    end

    it 'treats a doubly negated condition as not negated' do
      interaction = interaction_for(
        '<not><not><varequal respident="response1">111</varequal></not></not>'
      )
      expect(interaction.answer_feedback.first).not_to have_key(:negated)
    end

    it 'marks a singly negated condition as negated' do
      interaction = interaction_for('<not><varequal respident="response1">111</varequal></not>')
      expect(interaction.answer_feedback.first[:negated]).to be true
    end
  end
end
