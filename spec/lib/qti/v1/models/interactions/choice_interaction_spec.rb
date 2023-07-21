describe Qti::V1::Models::Interactions::ChoiceInteraction do
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

  shared_examples_for 'shuffled?' do
    it 'returns shuffle setting' do
      expect(loaded_class.shuffled?).to eq shuffle_value
    end
  end

  shared_examples_for 'locked_choices' do
    it 'returns locked choices setting' do
      expect(loaded_class.locked_choices).to eq locked_choices_value
    end
  end

  shared_examples_for 'answers' do
    it 'returns the answers' do
      expect(loaded_class.answers.count).to eq answer_choices_count
      expect(loaded_class.answers.first)
        .to be_an_instance_of(Qti::V1::Models::Choices::LogicalIdentifierChoice)
    end
  end

  shared_examples_for 'meta_type' do
    it 'returns interaction type from canvas meta data' do
      expect(loaded_class.meta_type).to eq meta_type
    end
  end

  context 'multiple_choice.xml' do
    let(:file_path) { File.join(fixtures_path, 'multiple_choice.xml') }
    let(:shuffle_value) { false }
    let(:locked_choices_value) { [] }
    let(:answer_choices_count) { 5 }
    let(:meta_type) { nil }

    include_examples 'shuffled?'
    include_examples 'locked_choices'
    include_examples 'answers'
    include_examples 'meta_type'
  end

  context 'true_false.xml' do
    let(:file_path) { File.join(fixtures_path, 'true_false.xml') }
    let(:shuffle_value) { true }
    let(:locked_choices_value) { [0] }
    let(:answer_choices_count) { 2 }
    let(:meta_type) { 'true_false_question' }

    include_examples 'shuffled?'
    include_examples 'locked_choices'
    include_examples 'answers'
    include_examples 'meta_type'
  end

  context 'multiple_answer.xml' do
    let(:file_path) { File.join(fixtures_path, 'multiple_answer.xml') }
    let(:shuffle_value) { false }
    let(:locked_choices_value) { [] }

    include_examples 'shuffled?'
    include_examples 'locked_choices'
  end

  context 'multiple_answer_canvas.xml' do
    let(:file_path) { File.join(fixtures_path, 'multiple_answer_canvas.xml') }
    let(:shuffle_value) { false }
    let(:locked_choices_value) { [] }
    let(:answer_choices_count) { 4 }
    let(:meta_type) { 'multiple_answers_question' }

    include_examples 'shuffled?'
    include_examples 'locked_choices'
    include_examples 'meta_type'
  end

  context 'multiple respconditions with empty setvars' do
    let(:fixtures_path) { File.join('spec', 'fixtures', 'test_with_comments') }
    let(:file_path) do
      File.join(
        fixtures_path,
        'i6c88aaf29feba2ffa58a487a20665394',
        'i6c88aaf29feba2ffa58a487a20665394.xml'
      )
    end

    it 'loads the items' do
      expect(loaded_class.scoring_data_structs.count).to eq 1
    end
  end

  context 'encoded html text in answers' do
    let(:file_path) do
      File.join(fixtures_path, 'choice.xml')
    end
    let(:loaded_class) { described_class.new(assessment_item_refs.last, test_object) }

    it 'correctly processes decode html text' do
      expect(loaded_class.answers.second.item_body).to eq('a &amp;&amp; b')
    end
  end
end
