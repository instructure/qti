describe Qti::V1::Models::Interactions::BaseFillBlankInteraction do
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

  shared_examples_for 'canvas_fib_responses' do
    it 'returns the canvas_fib_responses' do
      expect(loaded_class.canvas_fib_responses).to eq(expected_blanks)
    end
  end

  context 'canvas_stem_items' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_fib_as_single.xml') }
    let(:simple_prompt) { 'fill in the [blank1]' }
    let(:simple_expected) do
      [
        { id: 'stem_0', position: 1, type: 'text', value: 'fill in the ' },
        { id: 'stem_1', position: 2, type: 'blank', blank_id: 'response_blank1', blank_name: 'word' }
      ]
    end
    let(:embedded_prompt) { '[[embedded] [groups]]' }
    let(:embedded_expected) do
      [
        { id: 'stem_0', position: 1, type: 'text', value: '[' },
        { id: 'stem_1', position: 2, type: 'text', value: '[embedded]' },
        { id: 'stem_2', position: 3, type: 'text', value: ' ' },
        { id: 'stem_3', position: 4, type: 'text', value: '[groups]' },
        { id: 'stem_4', position: 5, type: 'text', value: ']' }
      ]
    end
    it 'decomposes item prompts' do
      expect(loaded_class.canvas_stem_items(simple_prompt)).to eq(simple_expected)
      expect(loaded_class.canvas_stem_items(embedded_prompt)).to eq(embedded_expected)
    end
  end

  context 'canvas_multiple_dropdowns.xml' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_dropdowns.xml') }
    let(:expected_blanks) do
      [
        {
          id: 'response_color1',
          choices:
          [
            { id: '6548', position: 2, item_body: 'red' },
            { id: '5550', position: 3, item_body: 'plaid' }
          ]
        },
        {
          id: 'response_color2',
          choices:
          [
            { id: '6951', position: 2, item_body: 'blue' },
            { id: '4500', position: 3, item_body: 'paisely' }
          ]
        }
      ]
    end

    include_examples 'canvas_fib_responses'

    # The item comments a wrong choice before the correct one, and canvas emits
    # those comments ahead of the scoring conditions.
    it 'names each blank after its correct choice, not a commented one' do
      expect(loaded_class.blank_value('response_color1')).to eq('red')
      expect(loaded_class.blank_value('response_color2')).to eq('blue')
    end
  end

  context 'nq_multiple_dropdowns_answer_feedback.xml' do
    let(:file_path) { File.join(fixtures_path, 'nq_multiple_dropdowns_answer_feedback.xml') }

    # The item comments a wrong choice in the second and third blank after the
    # correct one, and new quizzes emits those comments after the scoring
    # conditions.
    it 'maps each blank to its correct choice, not to a commented one' do
      expect(loaded_class.correct_answer_map).to eq(
        'response_68857282-90bc-4881-83b0-e811ab0502a6' => '7c011c63-8e76-42eb-86ab-531cd03f98a4',
        'response_6702826b-84db-422a-bdd5-f14e759fcb5e' => 'f1046a5d-c476-450f-98bb-33997446d0b0',
        'response_4fc61c7b-83f8-4eba-ae21-747fb76f6ae9' => 'ac8c8556-2eb3-45ac-8994-9a04eff74614'
      )
    end

    it 'names each blank after its correct choice' do
      expect(loaded_class.blank_value('response_6702826b-84db-422a-bdd5-f14e759fcb5e')).to eq('aaa2')
      expect(loaded_class.blank_value('response_4fc61c7b-83f8-4eba-ae21-747fb76f6ae9')).to eq('aaa3')
    end
  end

  context 'canvas_multiple_fib.xml' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_fib.xml') }
    let(:expected_blanks) do
      [
        {
          id: 'response_color1',
          choices:
          [
            { id: '9799', item_body: 'red', position: 2 },
            { id: '5231', item_body: 'Red', position: 3 }
          ]
        },
        {
          id: 'response_color2',
          choices:
          [
            { id: '5939', item_body: 'blue', position: 2 },
            { id: '6364', item_body: 'Blue', position: 3 }
          ]
        }
      ]
    end

    include_examples 'canvas_fib_responses'
  end

  context 'canvas multiple fill in the blank questions with a single blank' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_fib_as_single.xml') }
    let(:expected_blanks) do
      [
        {
          id: 'response_blank1',
          choices:
          [
            { id: '3537', item_body: 'word', position: 2 }
          ]
        }
      ]
    end

    include_examples 'canvas_fib_responses'
  end

  context 'canvas multiple fill in the blank questions with a single blank' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_fib_extra_brackets.xml') }
    let(:expected_blanks) do
      [
        {
          id: 'response_1',
          choices:
          [
            { id: '8464', item_body: 'A', position: 2 },
            { id: '265', item_body: 'B', position: 3 },
            { id: '3002', item_body: 'C', position: 4 },
            { id: '1356', item_body: 'D', position: 5 },
            { id: '5614', item_body: 'E', position: 6 }
          ]
        },
        {
          id: 'response_2',
          choices:
          [
            { id: '4002', item_body: 'A', position: 2 },
            { id: '8630', item_body: 'B', position: 3 },
            { id: '7844', item_body: 'C', position: 4 },
            { id: '3602', item_body: 'D', position: 5 },
            { id: '9525', item_body: 'E', position: 6 }
          ]
        },
        {
          id: 'response_3',
          choices:
          [
            { id: '8390', item_body: 'A', position: 2 },
            { id: '8745', item_body: 'B', position: 3 },
            { id: '3760', item_body: 'C', position: 4 },
            { id: '7542', item_body: 'D', position: 5 },
            { id: '1523', item_body: 'E', position: 6 }
          ]
        },
        {
          id: 'response_4',
          choices:
          [
            { id: '3317', item_body: 'A', position: 2 },
            { id: '6768', item_body: 'B', position: 3 },
            { id: '5823', item_body: 'C', position: 4 },
            { id: '2492', item_body: 'D', position: 5 },
            { id: '4494', item_body: 'E', position: 6 }
          ]
        },
        {
          id: 'response_5',
          choices:
          [
            { id: '6742', item_body: 'A', position: 2 },
            { id: '794', item_body: 'B', position: 3 },
            { id: '4259', item_body: 'C', position: 4 },
            { id: '4851', item_body: 'D', position: 5 },
            { id: '8574', item_body: 'E', position: 6 }
          ]
        }
      ]
    end

    include_examples 'canvas_fib_responses'
  end
end
