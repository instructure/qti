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
end
