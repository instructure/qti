describe Qti::V1::Models::Interactions::NumericInteraction do
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:file_path) { File.join(fixtures_path, xml_file_name) }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }

  shared_examples_for 'scoring_data_structs' do |items|
    items.each do |key, values|
      it 'returns the scoring_data_structs' do
        expect(loaded_class.scoring_data_structs.map(&key)).to eq(values)
      end
    end
  end

  context 'exact match' do
    let(:xml_file_name) { 'numeric_exact_match.xml' }
    context 'the first item in numeric_exact_match.xml' do
      let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
      let(:answer_count) { 1 }

      include_examples 'scoring_data_structs', id: %w[response1], value: %w[1234.0]
    end

    context 'the second item in numeric_exact_match.xml' do
      let(:loaded_class) { described_class.new(assessment_item_refs[1], test_object) }
      let(:scoring_data_ids) { %w[response1 response1 response1] }
      let(:scoring_data_values) { %w[4321.0 1234.0 1111.0] }
      let(:verification_data) do
        [{ id: scoring_data_ids }, { value: scoring_data_values }]
      end
      let(:answer_count) { 3 }

      include_examples(
        'scoring_data_structs',
        id: %w[response1 response1 response1],
        value: %w[4321.0 1234.0 1111.0]
      )
    end

    context '#item_body' do
      let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
      it 'returns right title' do
        expect(loaded_class.item_body).to eq '<div><p>question 1</p></div>'
      end
    end
  end

  context 'margin error' do
    let(:xml_file_name) { 'numeric_margin_error.xml' }
    context 'the first item in numeric_margin_error.xml' do
      let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
      let(:answer_count) { 1 }

      include_examples 'scoring_data_structs',
        id: %w[response1],
        type: %w[marginOfError],
        value: %w[77.0],
        margin: %w[7.0],
        margin_type: %w[absolute]
    end

    context '#item_body' do
      let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
      it 'returns right title' do
        expect(loaded_class.item_body).to eq '<div><p>QQ1.margin error</p></div>'
      end
    end

    context 'with explicit margin and margin_type' do
      let(:xml_file_name) { 'numeric_margin_error_percent.xml' }
      context 'the first item in numeric_margin_error.xml' do
        let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
        let(:answer_count) { 1 }

        include_examples 'scoring_data_structs',
          id: %w[response1],
          type: %w[marginOfError],
          value: %w[200.0],
          margin: %w[20.0],
          margin_type: %w[percent]
      end
    end
  end

  context 'precision' do
    let(:xml_file_name) { 'numeric_precision.xml' }
    context 'the first item in numeric_precision.xml' do
      let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
      let(:answer_count) { 1 }

      include_examples 'scoring_data_structs',
        id: %w[response1],
        type: %w[preciseResponse],
        value: %w[1000.00],
        precision: %w[6],
        precision_type: %w[significantDigits]
    end

    context '#item_body' do
      let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
      it 'returns right title' do
        expect(loaded_class.item_body).to eq '<div><p>QQ1.presision ss</p></div>'
      end
    end

    context 'with explicit precision and precision_type' do
      let(:xml_file_name) { 'numeric_precision_decimals.xml' }

      context 'the first item in numeric_precision_decimals.xml' do
        let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
        let(:answer_count) { 1 }

        include_examples 'scoring_data_structs',
          id: %w[response1],
          type: %w[preciseResponse],
          value: %w[100.1234],
          precision: %w[4],
          precision_type: %w[decimals]
      end
    end
  end

  context 'wthin range' do
    let(:xml_file_name) { 'numeric_within_range.xml' }
    context 'the first item in numeric_within_range.xml' do
      let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
      let(:answer_count) { 1 }

      include_examples 'scoring_data_structs',
        id: %w[response1],
        type: %w[withinARange],
        start: %w[1.0],
        end: %w[22.0]
    end

    context '#item_body' do
      let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }
      it 'returns right title' do
        expect(loaded_class.item_body).to eq '<div><p>QQ1</p></div>'
      end
    end
  end

  context 'answer feedback' do
    let(:xml_file_name) { 'numeric_answer_feedback.xml' }

    context 'a question with a comment on every answer type' do
      let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

      it 'returns a comment for the exact, precision, margin of error and range answers' do
        expect(loaded_class.answer_feedback).to eq(
          [
            { response_index: 0, texttype: 'text/html', feedback: '<p>Exact answer comment</p>' },
            { response_index: 1, texttype: 'text/html', feedback: '<p>Precision answer comment</p>' },
            { response_index: 2, texttype: 'text/html', feedback: '<p>Margin of error answer comment</p>' },
            { response_index: 3, texttype: 'text/html', feedback: '<p>Range answer comment</p>' }
          ]
        )
      end

      it 'aligns every response_index with the matching scoring_data_struct' do
        structs = loaded_class.scoring_data_structs
        expect(structs.map(&:type)).to eq(
          %w[exactResponse preciseResponse marginOfError withinARange]
        )
        expect(loaded_class.answer_feedback.map { |fb| structs[fb[:response_index]].type }).to eq(
          %w[exactResponse preciseResponse marginOfError withinARange]
        )
      end

      it 'ignores the item level feedback' do
        expect(loaded_class.answer_feedback.map { |fb| fb[:feedback] }).not_to include(
          '<p>General Correct Feedback</p>', '<p>General Feedback</p>'
        )
      end
    end

    context 'a question where only some answers have a comment' do
      let(:loaded_class) { described_class.new(assessment_item_refs[1], test_object) }

      it 'keeps the index of the commented answers aligned with scoring_data_structs' do
        expect(loaded_class.answer_feedback).to eq(
          [
            { response_index: 0, texttype: 'text/html', feedback: '<p>First answer comment</p>' },
            { response_index: 2, texttype: 'text/html', feedback: '<p>Third answer comment</p>' }
          ]
        )
        expect(loaded_class.scoring_data_structs.map(&:value)).to eq(%w[10.0 20.0 30.0])
      end
    end
  end

  context 'without answer feedback' do
    let(:xml_file_name) { 'numeric_exact_match.xml' }
    let(:loaded_class) { described_class.new(assessment_item_refs[1], test_object) }

    it 'returns nil' do
      expect(loaded_class.answer_feedback).to be_nil
    end
  end
end
