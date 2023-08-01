describe Qti::V1::Models::Assessment do
  describe 'interaction item' do
    let(:fixtures_path) { File.join('spec', 'fixtures') }
    shared_examples_for 'basic quiz fields' do
      it 'loads an AssessmentXML file' do
        expect do
          described_class.from_path!(path)
        end.to_not raise_error
      end

      describe '#title' do
        context '<assessmentTest> has a title property' do
          it 'has the title' do
            expect(loaded_class.title).to eq(expected_title)
          end
        end

        it 'it has the correct number of items' do
          expect(loaded_class.assessment_items.count).to eq(expected_item_count)
        end
      end

      describe '#identifier' do
        it 'has the identifier' do
          expect(loaded_class.identifier).to eq(expected_identifier)
        end
      end
    end

    shared_examples_for 'verify quiz items' do
      it 'has the correct item data' do
        loaded_class.assessment_items.zip(expected_item_data).each do |node, cmp|
          item = Qti::V1::Models::AssessmentItem.new(node)
          expect(item.interaction_model.class).to eq(cmp[:interaction_class])
          expect(item.title).to eq(cmp[:title])
          expect(item.feedback).to eq(cmp[:feedback])
        end
      end
    end

    context 'reference qti 1.2 quiz' do
      let(:path) { File.join(fixtures_path, 'test_qti_1.2', 'quiz.xml') }
      let(:loaded_class) { described_class.from_path!(path) }
      let(:expected_title) { '1.2 Import Quiz' }
      let(:expected_identifier) { 'A1001' }
      let(:expected_item_count) { 5 }

      include_examples('basic quiz fields')
    end

    context 'quiz with feedback samples' do
      let(:path) { File.join(fixtures_path, 'feedback_quiz_1.2.xml') }
      let(:loaded_class) { described_class.from_path!(path) }
      let(:expected_title) { 'I Can Haz Feedback' }
      let(:expected_identifier) { 'i618e88580f76f70a1ed28804f497df9c' }
      let(:expected_item_count) { 3 }
      let(:expected_item_data) do
        [
          {
            interaction_class: Qti::V1::Models::Interactions::StringInteraction,
            title: 'Question',
            feedback: { neutral: '<p>General Feedback</p>' }
          },
          {
            interaction_class: Qti::V1::Models::Interactions::ChoiceInteraction,
            title: 'Question',
            feedback: { neutral: '<p>Neutral</p>', correct: '<p>Correct</p>', incorrect: '<p>Incorrect</p>' }
          },
          {
            interaction_class: Qti::V1::Models::Interactions::ChoiceInteraction,
            title: 'Question',
            feedback: {}
          }
        ]
      end

      include_examples('basic quiz fields')
      include_examples('verify quiz items')
    end

    context 'reference qti 1.2 quiz' do
      let(:path) { File.join(fixtures_path, 'all_canvas_simple_1.2.xml') }
      let(:loaded_class) { described_class.from_path!(path) }
      let(:expected_title) { 'Every Canvas Interaction' }
      let(:expected_identifier) { 'ie09bc528e6ecd1cb9ebfafd940c20215' }
      let(:expected_item_count) { 10 }
      let(:expected_item_data) do
        [
          {
            interaction_class: Qti::V1::Models::Interactions::ChoiceInteraction,
            title: 'Question 1',
            feedback: {
              neutral: '<p>Item Feedback, Neutral</p>',
              correct: '<p>Item Feedback, Correct</p>',
              incorrect: '<p>Item Feedback, Incorrect</p>'
            }
          },
          {
            interaction_class: Qti::V1::Models::Interactions::ChoiceInteraction,
            title: 'Question 2',
            feedback: {
              neutral: '<p>Item Feedback, Neutral</p>',
              correct: '<p>Item Feedback, Correct</p>',
              incorrect: '<p>Item Feedback, Incorrect</p>'
            }
          },
          {
            interaction_class: Qti::V1::Models::Interactions::FillBlankInteraction,
            title: 'Question 3',
            feedback: {
              neutral: '<p>Item Feedback, Neutral</p>',
              correct: '<p>Item Feedback, Correct</p>',
              incorrect: '<p>Item Feedback, Incorrect</p>'
            }
          },
          {
            interaction_class: Qti::V1::Models::Interactions::FillBlankInteraction,
            title: 'Question 4',
            feedback: {
              neutral: '<p>Item Feedback, Neutral</p>',
              correct: '<p>Item Feedback, Correct</p>',
              incorrect: '<p>Item Feedback, Incorrect</p>'
            }
          },
          {
            interaction_class: Qti::V1::Models::Interactions::ChoiceInteraction,
            title: 'Question 5',
            feedback: {
              neutral: '<p>Item Feedback, Neutral</p>',
              correct: '<p>Item Feedback, Correct</p>',
              incorrect: '<p>Item Feedback, Incorrect</p>'
            }
          },
          {
            interaction_class: Qti::V1::Models::Interactions::CanvasMultipleDropdownInteraction,
            title: 'Question 6',
            feedback: {
              neutral: '<p>Item Feedback, Neutral</p>',
              correct: '<p>Item Feedback, Correct</p>',
              incorrect: '<p>Item Feedback, Incorrect</p>'
            }
          },
          {
            interaction_class: Qti::V1::Models::Interactions::MatchInteraction,
            title: 'Question 7',
            feedback: {
              neutral: '<p>Item Feedback, Neutral</p>',
              correct: '<p>Item Feedback, Correct</p>',
              incorrect: '<p>Item Feedback, Incorrect</p>'
            }
          },
          {
            interaction_class: Qti::V1::Models::Interactions::NumericInteraction,
            title: 'Question 8',
            feedback: {
              neutral: '<p>Item Feedback, Neutral</p>',
              correct: '<p>Item Feedback, Correct</p>',
              incorrect: '<p>Item Feedback, Incorrect</p>'
            }
          },
          {
            interaction_class: Qti::V1::Models::Interactions::FormulaInteraction,
            title: 'Question 9',
            feedback: {
              neutral: '<p>Item Feedback, Neutral</p>',
              correct: '<p>Item Feedback, Correct</p>',
              incorrect: '<p>Item Feedback, Incorrect</p>'
            }
          },
          {
            interaction_class: Qti::V1::Models::Interactions::StringInteraction,
            title: 'Question 10',
            feedback: { neutral: '<p>Item Feedback, Neutral</p>' }
          }
        ]
      end
      include_examples('basic quiz fields')
      include_examples('verify quiz items')
    end

    context '<assessmentTest> has no title property' do
      it 'sets the title to the filename by default' do
        allow(File).to receive(:read).and_return(<<~XML)
          <?xml version="1.0" encoding="UTF-8"?>
          <questestinterop xmlns="http://www.imsglobal.org/xsd/ims_qtiasiv1p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd">
            <assessment ident="A1001">
            </assessment>
          </questestinterop>
        XML
        assessment_test = described_class.new path: '/a/b/c/Test123.xml'
        expect(assessment_test.title).to eq 'Test123'
      end
    end
  end

  describe 'stimulus (text-no-question) item' do
    let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
    let(:test_object) { described_class.from_path!(file_path) }
    let(:assessment_item_refs) { test_object.assessment_items }
    let(:assessment_item_ref) { assessment_item_refs.first }
    let(:file_path) { File.join(fixtures_path, 'text.no.question.xml') }

    it 'methods behave as expected' do
      expect(
        test_object.create_assessment_item(assessment_item_ref)
      ).to eq(nil)

      expect(
        test_object.stimulus_ref(assessment_item_ref)
      ).to eq(assessment_item_ref)

      expect(
        test_object.create_stimulus(assessment_item_ref).class
      ).to be(Qti::V1::Models::StimulusItem)
    end
  end

  describe 'question group items' do
    let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
    let(:test_object) { described_class.from_path!(file_path) }
    let(:assessment_item_refs) { test_object.assessment_items }
    let(:assessment_item_ref) { assessment_item_refs.first }
    let(:file_path) { File.join(fixtures_path, 'question_group.xml') }

    it 'methods behave as expected' do
      expect(
        test_object.create_assessment_item(assessment_item_ref)
      ).to eq(nil)
    end
  end

  describe 'bank entry items' do
    let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
    let(:test_object) { described_class.from_path!(file_path) }
    let(:assessment_item_refs) { test_object.assessment_items }
    let(:assessment_item_ref) { assessment_item_refs.first }
    let(:file_path) { File.join(fixtures_path, 'bank_entry_item.xml') }

    it 'methods behave as expected' do
      expect(
        test_object.create_assessment_item(assessment_item_ref)
      ).to eq(nil)

      expect(
        test_object.create_bank_entry_item(assessment_item_ref).class
      ).to be(Qti::V1::Models::BankEntryItem)
    end
  end
end
