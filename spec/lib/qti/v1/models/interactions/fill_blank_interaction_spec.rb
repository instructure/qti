describe Qti::V1::Models::Interactions::FillBlankInteraction do
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

  shared_examples_for 'shuffled?' do
    it 'returns shuffle setting' do
      expect(loaded_class.shuffled?).to eq shuffle_value
    end
  end

  shared_examples_for 'blanks' do
    it 'returns the blanks' do
      expect(loaded_class.blanks).to eq(expected_blanks)
    end
  end

  shared_examples_for 'answers' do
    it 'returns the answers' do
      expect(loaded_class.answers.count).to eq answer_count
      expect(loaded_class.answers.first).to be_an_instance_of(Qti::V1::Models::Choices::FillBlankChoice)
    end
  end

  shared_examples_for 'scoring_data_structs' do
    it 'returns the scoring_data_structs' do
      expect(loaded_class.scoring_data_structs.map(&:id)).to eq(scoring_data_ids)
      expect(loaded_class.scoring_data_structs.map(&:values)).to eq(scoring_data_values)
      expect(loaded_class.scoring_data_structs.map(&:case)).to eq(scoring_data_case)
    end
  end

  shared_examples_for 'nq_scoring_data_structs' do
    it 'returns the scoring_data_structs' do
      expect(loaded_class.scoring_data_structs.map(&:scoring_algorithm)).to eq(scoring_data_algorithm)
      expect(loaded_class.scoring_data_structs.map(&:answer_type)).to eq(scoring_data_answer_type)
      expect(loaded_class.scoring_data_structs.map(&:scoring_options)).to eq(scoring_data_options)
    end
  end

  shared_examples_for 'stem_items' do
    it 'returns the stem_items' do
      expect(loaded_class.stem_items).to eq(expected_stem_items)
    end
  end

  context 'single_fib.xml' do
    let(:file_path) { File.join(fixtures_path, 'single_fib.xml') }
    let(:scoring_data_ids) { %w[response1 response1] }
    let(:scoring_data_values) { %w[Illinois illinois] }
    let(:scoring_data_case) { %w[no no] }
    let(:answer_count) { 2 }
    let(:expected_blanks) { [{ id: 'response1' }] }
    let(:expected_stem_items) do
      [
        { id: 'stem_0', position: 1, type: 'text', value: '<div><p>Chicago is in what state?</p></div>' },
        { id: 'stem_1', position: 2, type: 'blank', blank_id: 'response1', blank_name: 'Illinois' }
      ]
    end

    include_examples 'answers'
    include_examples 'scoring_data_structs'
    include_examples 'blanks'
    include_examples 'stem_items'

    it 'returns true for #single_fill_in_blank?' do
      expect(loaded_class.single_fill_in_blank?).to eq true
    end
  end

  context 'canvas_multiple_fib.xml' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_fib.xml') }
    let(:shuffle_value) { false }
    let(:scoring_data_ids) { %w[9799 5231 5939 6364] }
    let(:scoring_data_values) { %w[red Red blue Blue] }
    let(:scoring_data_case) { %w[no no no no] }
    let(:answer_count) { 4 }
    let(:expected_blanks) { [{ id: '9799' }, { id: '5231' }, { id: '5939' }, { id: '6364' }] }
    let(:expected_stem_items) do
      [
        { id: 'stem_0', position: 1, type: 'text', value: '<div><p><span>Roses are ' },
        { id: 'stem_1', position: 2, type: 'blank', blank_id: 'response_color1', blank_name: 'red' },
        { id: 'stem_2', position: 3, type: 'text', value: ', violets are ' },
        { id: 'stem_3', position: 4, type: 'blank', blank_id: 'response_color2', blank_name: 'blue' },
        { id: 'stem_4', position: 5, type: 'text', value: '</span></p></div>' }
      ]
    end

    include_examples 'shuffled?'
    include_examples 'answers'
    include_examples 'scoring_data_structs'
    include_examples 'blanks'
    include_examples 'stem_items'

    it 'returns false for #single_fill_in_blank?' do
      expect(loaded_class.single_fill_in_blank?).to eq false
    end
  end

  context 'fib_str.xml' do
    let(:file_path) { File.join(fixtures_path, 'fib_str.xml') }
    let(:shuffle_value) { false }
    let(:scoring_data_ids) { %w[FIB01 FIB02 FIB03] }
    let(:scoring_data_values) { %w[Winter Summer York] }
    let(:scoring_data_case) { %w[Yes Yes Yes] }
    let(:answer_count) { 3 }
    let(:expected_blanks) { [{ id: 'FIB01' }, { id: 'FIB02' }, { id: 'FIB03' }] }
    let(:expected_stem_items) do
      [
        { id: 'stem_0', position: 1, type: 'text', value: 'Fill-in-the blanks in this text from Richard III: ' },
        { id: 'stem_1', position: 2, type: 'text', value: 'Now is the ' },
        { id: 'stem_2', position: 3, type: 'blank', blank_id: 'FIB01', blank_name: 'Winter' },
        { id: 'stem_3', position: 4, type: 'text', value: ' of our discontent made glorious ' },
        { id: 'stem_4', position: 5, type: 'blank', blank_id: 'FIB02', blank_name: 'Summer' },
        { id: 'stem_5', position: 6, type: 'text', value: ' by these sons of ' },
        { id: 'stem_6', position: 7, type: 'blank', blank_id: 'FIB03', blank_name: 'York' }
      ]
    end

    include_examples 'shuffled?'
    include_examples 'answers'
    include_examples 'scoring_data_structs'
    include_examples 'blanks'
    include_examples 'stem_items'

    it 'returns false for #single_fill_in_blank?' do
      expect(loaded_class.single_fill_in_blank?).to eq false
    end
  end

  context 'fib_feedback.xml' do
    let(:file_path) { File.join(fixtures_path, 'fib_feedback.xml') }
    let(:shuffle_value) { false }
    let(:scoring_data_ids) { %w[response1 response1 response1] }
    let(:scoring_data_values) { %w[blank Blank BLANK] }
    let(:scoring_data_case) { %w[no no no] }
    let(:answer_count) { 3 }
    let(:expected_blanks) { [{ id: 'response1' }] }

    include_examples 'shuffled?'
    include_examples 'answers'
    include_examples 'scoring_data_structs'
    include_examples 'blanks'
  end

  describe '#scoring_data_structs' do
    let(:nodexml) { double }
    let(:test_object) { double(package_root: 'dummy', path: 'dummy/blah') }
    subject { described_class.new(nodexml, test_object) }

    it "returns 'no' as case default value" do
      allow(nodexml).to receive(:at_xpath)
      node = double(
        parent: double(parent: double(attributes: 'a')),
        content: 'content',
        attributes: { respident: double(value: 'a') }
      )
      allow(subject).to receive(:answer_nodes).and_return([node])
      expect(subject.scoring_data_structs.first.case).to eq 'no'
    end

    it "returns 'TextInChoices' as scoring algorithm default value" do
      allow(nodexml).to receive(:at_xpath)
      node = double(
        parent: double(parent: double(attributes: 'a')),
        content: 'content',
        attributes: { respident: double(value: 'a') }
      )
      allow(subject).to receive(:answer_nodes).and_return([node])
      expect(subject.scoring_data_structs.first.scoring_algorithm).to eq 'TextInChoices'
    end

    it "returns 'openEntry' as answer type default value" do
      allow(nodexml).to receive(:at_xpath)
      node = double(
        parent: double(parent: double(attributes: 'a')),
        content: 'content',
        attributes: { respident: double(value: 'a') }
      )
      allow(subject).to receive(:answer_nodes).and_return([node])
      expect(subject.scoring_data_structs.first.answer_type).to eq 'openEntry'
    end
  end

  context 'fib_str.xml' do
    let(:file_path) { File.join(fixtures_path, 'fib_str.xml') }
    let(:shuffle_value) { false }
    let(:scoring_data_ids) { %w[FIB01 FIB02 FIB03] }
    let(:scoring_data_values) { %w[Winter Summer York] }
    let(:scoring_data_case) { %w[Yes Yes Yes] }
    let(:answer_count) { 3 }
    let(:expected_blanks) { [{ id: 'FIB01' }, { id: 'FIB02' }, { id: 'FIB03' }] }
    let(:expected_stem_items) do
      [
        { id: 'stem_0', position: 1, type: 'text', value: 'Fill-in-the blanks in this text from Richard III: ' },
        { id: 'stem_1', position: 2, type: 'text', value: 'Now is the ' },
        { id: 'stem_2', position: 3, type: 'blank', blank_id: 'FIB01', blank_name: 'Winter' },
        { id: 'stem_3', position: 4, type: 'text', value: ' of our discontent made glorious ' },
        { id: 'stem_4', position: 5, type: 'blank', blank_id: 'FIB02', blank_name: 'Summer' },
        { id: 'stem_5', position: 6, type: 'text', value: ' by these sons of ' },
        { id: 'stem_6', position: 7, type: 'blank', blank_id: 'FIB03', blank_name: 'York' }
      ]
    end

    include_examples 'shuffled?'
    include_examples 'answers'
    include_examples 'scoring_data_structs'
    include_examples 'blanks'
    include_examples 'stem_items'

    it 'returns false for #single_fill_in_blank?' do
      expect(loaded_class.single_fill_in_blank?).to eq false
    end
  end

  context 'canvas multiple fill in the blank questions with a single blank' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_fib_as_single.xml') }
    let(:shuffle_value) { false }
    let(:scoring_data_ids) { %w[3537] }
    let(:scoring_data_values) { %w[word] }
    let(:scoring_data_case) { %w[no] }
    let(:answer_count) { 1 }
    let(:expected_blanks) { [{ id: '3537' }] }

    include_examples 'shuffled?'
    include_examples 'answers'
    include_examples 'scoring_data_structs'
    include_examples 'blanks'

    it 'returns false for #single_fill_in_blank?' do
      expect(loaded_class.single_fill_in_blank?).to eq false
    end
  end

  context 'new quizzes multiple fill in the blank questions with all possible scoring algorithms' do
    let(:file_path) { File.join(fixtures_path, 'nq_multiple_fib_scoring_algorithms.xml') }
    let(:scoring_data_ids) do
      %w[bafd8242-ecdb-4158-a6d3-4ff15e016cb8-0
         d719aee0-6ce0-462c-9c0d-be63ba8d3408-0
         ce47aaf6-c1dd-4db8-9a9f-7f5c131d8a90-0
         41dfd716-8fd9-466a-97fa-33d353e44b42-0
         41dfd716-8fd9-466a-97fa-33d353e44b42-1
         a053119f-6a61-4372-ac79-4b2a7de0232f-0]
    end
    let(:scoring_data_values) { %w[red blue green yellow teal ^orange$] }
    let(:scoring_data_case) { %w[no no no no no no] }
    let(:scoring_data_algorithm) do
      %w[TextContainsAnswer TextCloseEnough TextEquivalence TextInChoices TextInChoices TextRegex]
    end
    let(:scoring_data_answer_type) { %w[openEntry openEntry openEntry openEntry openEntry openEntry] }
    let(:scoring_data_options) { [{}, { 'ignore_case' => 'true', 'levenshtein_distance' => '1' }, {}, {}, {}, {}] }
    let(:correct_answer_map) do
      { 'response_bafd8242-ecdb-4158-a6d3-4ff15e016cb8' => 'bafd8242-ecdb-4158-a6d3-4ff15e016cb8-0',
        'response_d719aee0-6ce0-462c-9c0d-be63ba8d3408' => 'd719aee0-6ce0-462c-9c0d-be63ba8d3408-0',
        'response_ce47aaf6-c1dd-4db8-9a9f-7f5c131d8a90' => 'ce47aaf6-c1dd-4db8-9a9f-7f5c131d8a90-0',
        'response_41dfd716-8fd9-466a-97fa-33d353e44b42' => '41dfd716-8fd9-466a-97fa-33d353e44b42-0',
        'response_a053119f-6a61-4372-ac79-4b2a7de0232f' => 'a053119f-6a61-4372-ac79-4b2a7de0232f-0' }
    end
    let(:expected_stem_items) do
      [{ id: 'stem_0', position: 1, type: 'text', value: '<p>Roses are ' },
       { blank_id: 'response_bafd8242-ecdb-4158-a6d3-4ff15e016cb8',
         blank_name: 'red',
         id: 'stem_1',
         position: 2,
         type: 'blank' },
       { id: 'stem_2', position: 3, type: 'text', value: ', ' },
       { blank_id: 'response_d719aee0-6ce0-462c-9c0d-be63ba8d3408',
         blank_name: 'blue',
         id: 'stem_3',
         position: 4,
         type: 'blank' },
       { id: 'stem_4', position: 5, type: 'text', value: ', ' },
       { blank_id: 'response_ce47aaf6-c1dd-4db8-9a9f-7f5c131d8a90',
         blank_name: 'green',
         id: 'stem_5',
         position: 6,
         type: 'blank' },
       { id: 'stem_6', position: 7, type: 'text', value: ', ' },
       { blank_id: 'response_41dfd716-8fd9-466a-97fa-33d353e44b42',
         blank_name: 'yellow',
         id: 'stem_7',
         position: 8,
         type: 'blank' },
       { id: 'stem_8', position: 9, type: 'text', value: ', and ' },
       { blank_id: 'response_a053119f-6a61-4372-ac79-4b2a7de0232f',
         blank_name: '^orange$',
         id: 'stem_9',
         position: 10,
         type: 'blank' },
       { id: 'stem_10', position: 11, type: 'text', value: '.</p>' }]
    end

    include_examples 'scoring_data_structs'
    include_examples 'nq_scoring_data_structs'
    include_examples 'stem_items'

    it 'returns false for #wordbank_answer_present?' do
      expect(loaded_class.wordbank_answer_present?).to eq false
    end

    it 'returns nil for #wordbank_allow_reuse?' do
      expect(loaded_class.wordbank_allow_reuse?).to eq nil
    end

    it 'returns nil for #wordbank_choices' do
      expect(loaded_class.wordbank_choices).to eq nil
    end

    it 'returns the answer map for #correct_answer_map' do
      expect(loaded_class.correct_answer_map).to eq(correct_answer_map)
    end
  end

  context 'new quizzes multiple fill in the blank questions with all possible answer types' do
    let(:file_path) { File.join(fixtures_path, 'nq_multiple_fib_answer_types.xml') }
    let(:scoring_data_ids) do
      %w[378646a8-b823-4e5b-beb8-19ca63f1f355
         c9400bfb-78ea-45b6-b5a5-e3311f6d5ed0
         76350749-49ac-4094-966b-c4e1f12d54bc
         cd11d826-906d-4dc4-b78d-d66516eb94ce
         bae0bd4f-2327-4a3e-b29f-199e1e279e91
         cd11d826-906d-4dc4-b78d-d66516eb94ce
         bae0bd4f-2327-4a3e-b29f-199e1e279e91]
    end
    let(:scoring_data_values) { %w[black violet grey brown white brown white] }
    let(:scoring_data_case) { %w[no no no no no no no] }
    let(:scoring_data_algorithm) do
      %w[
        Equivalence
        Equivalence
        Equivalence
        TextEquivalence
        TextEquivalence
        TextEquivalence
        TextEquivalence
      ]
    end
    let(:scoring_data_answer_type) { %w[dropdown dropdown dropdown wordbank wordbank wordbank wordbank] }
    let(:scoring_data_options) do
      [
        {},
        {},
        {},
        { 'allow_reuse' => 'true' },
        { 'allow_reuse' => 'true' },
        { 'allow_reuse' => 'true' },
        { 'allow_reuse' => 'true' }
      ]
    end
    let(:wordbank_choices) do
      [{ id: 'cd11d826-906d-4dc4-b78d-d66516eb94ce', item_body: 'brown' },
       { id: 'bae0bd4f-2327-4a3e-b29f-199e1e279e91', item_body: 'white' }]
    end
    let(:correct_answer_map) do
      { 'response_a20629ed-0c0b-4959-b565-a80c0f199602' => '378646a8-b823-4e5b-beb8-19ca63f1f355',
        'response_ab37a945-ebad-4787-a356-66c3c91efcc6' => 'bae0bd4f-2327-4a3e-b29f-199e1e279e91',
        'response_ab37a945-ebad-4787-a356-66c3c91efcc7' => 'cd11d826-906d-4dc4-b78d-d66516eb94ce' }
    end
    let(:expected_stem_items) do
      [{ id: 'stem_0', position: 1, type: 'text', value: '<p>Roses are ' },
       { blank_id: 'response_a20629ed-0c0b-4959-b565-a80c0f199602',
         blank_name: 'black',
         id: 'stem_1',
         position: 2,
         type: 'blank' },
       { id: 'stem_2', position: 3, type: 'text', value: ', ' },
       { blank_id: 'response_ab37a945-ebad-4787-a356-66c3c91efcc6',
         blank_name: 'white',
         id: 'stem_3',
         position: 4,
         type: 'blank' },
       { id: 'stem_4', position: 5, type: 'text', value: ', and ' },
       { blank_id: 'response_ab37a945-ebad-4787-a356-66c3c91efcc7',
         blank_name: 'brown',
         id: 'stem_5',
         position: 6,
         type: 'blank' },
       { id: 'stem_6', position: 7, type: 'text', value: '.</p>' }]
    end

    include_examples 'scoring_data_structs'
    include_examples 'nq_scoring_data_structs'
    include_examples 'stem_items'

    it 'returns true for #wordbank_answer_present?' do
      expect(loaded_class.wordbank_answer_present?).to eq true
    end

    it 'returns true for #wordbank_allow_reuse?' do
      expect(loaded_class.wordbank_allow_reuse?).to eq true
    end

    it 'returns the correct choices for #wordbank_choices' do
      expect(loaded_class.wordbank_choices).to eq(wordbank_choices)
    end

    it 'returns the answer map for #correct_answer_map' do
      expect(loaded_class.correct_answer_map).to eq(correct_answer_map)
    end
  end
end
