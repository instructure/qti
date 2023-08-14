describe Qti::V1::Models::Interactions::FormulaInteraction do
  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

  shared_examples_for 'scoring_data_structs' do
    it 'reads scoring_data_structs' do
      expect(loaded_class.scoring_data_structs.map(&:values)).to eq(scoring_data_values)
    end
  end

  shared_examples_for 'reading_formulas' do
    it 'reads formulas correctly' do
      expect(loaded_class.formula_decimal_places).to eq(formula_decimal_places)
      expect(loaded_class.formula_scientific_notation).to eq(formula_scientific_notation)
      expect(loaded_class.formulas).to eq(formula_formulas)
    end
  end

  shared_examples_for 'answer_tolerance' do
    it 'reads answer_tolernace correctly' do
      expect(loaded_class.answer_tolerance).to eq(answer_tolerance)
    end

    it 'generates do margin_of_error' do
      expect(loaded_class.margin_of_error).to eq(margin_of_error)
    end
  end

  shared_examples_for 'variables' do
    it('returns the correct variable definitions') do
      expect(loaded_class.variables).to eq(variables)
    end
  end

  context 'Simple Formula' do
    let(:file_path) { File.join(fixtures_path, 'formula.xml') }

    let(:scoring_data_values) { [9.0, 9.0, 6.0, 2.0, 3.0] }

    let(:answer_tolerance) { '0' }
    let(:margin_of_error) { { margin: '0', margin_type: 'absolute' } }
    let(:formula_decimal_places) { '0' }
    let(:formula_scientific_notation) { false }
    let(:formula_formulas) { ['x'] }

    let(:item_title) { '<div><p>What number is [x]</p></div>' }

    let(:variables) { [{ name: 'x', min: 1.0, max: 10.0, precision: 0 }] }

    include_examples 'scoring_data_structs'
    include_examples 'reading_formulas'
    include_examples 'answer_tolerance'
    include_examples 'variables'
  end

  context 'Multiple variable formula' do
    let(:file_path) { File.join(fixtures_path, 'formula_mvar.xml') }

    let(:scoring_data_values) { [16.0, 7.0, 14.0, 5.0, 7.0, 14.0, 11.0, 7.0, 20.0, 13.0] }

    let(:answer_tolerance) { '0' }
    let(:margin_of_error) { { margin: '0', margin_type: 'absolute' } }
    let(:formula_decimal_places) { '0' }
    let(:formula_scientific_notation) { false }
    let(:formula_formulas) { ['x+y'] }

    let(:item_title) { '<div><p>[x] + [y]</p></div>' }

    let(:variables) do
      [{ name: 'x', min: 1.0, max: 10.0, precision: 0 },
       { name: 'y', min: 1.0, max: 10.0, precision: 0 }]
    end

    include_examples 'scoring_data_structs'
    include_examples 'answer_tolerance'
    include_examples 'reading_formulas'
    include_examples 'variables'
  end

  context 'Multiple Formula Steps' do
    let(:file_path) { File.join(fixtures_path, 'formula_mform.xml') }

    let(:scoring_data_values) { [82.58, 23.72, 39.75, 46.25, 41.03] }

    let(:answer_tolerance) { '10%' }
    let(:margin_of_error) { { margin: '10', margin_type: 'percent' } }
    let(:formula_decimal_places) { '2' }
    let(:formula_scientific_notation) { false }
    let(:formula_formulas) { ['x=n*x', 'y=m*y', 'x+y'] }

    let(:item_title) { '<div><p>[n][x] + [m][y]</p></div>' }

    let(:variables) do
      [{ name: 'y', min: 1.0, max: 10.0, precision: 2 },
       { name: 'x', min: 1.0, max: 10.0, precision: 2 },
       { name: 'n', min: 1.0, max: 10.0, precision: 2 },
       { name: 'm', min: 1.0, max: 10.0, precision: 2 }]
    end

    include_examples 'scoring_data_structs'
    include_examples 'answer_tolerance'
    include_examples 'reading_formulas'
    include_examples 'variables'
  end

  context 'Formula with scientific notation' do
    let(:file_path) { File.join(fixtures_path, 'formula_scientific.xml') }

    let(:scoring_data_values) { ['1*10^1', '7*10^0'] }

    let(:answer_tolerance) { '0' }
    let(:formula_decimal_places) { '0' }
    let(:formula_scientific_notation) { true }
    let(:formula_formulas) { ['x'] }
    let(:margin_of_error) { { margin: '0', margin_type: 'absolute' } }
    let(:formula_formulas) { ['5+x'] }

    let(:item_title) { '<div><p>What number is [x]</p></div>' }

    let(:variables) { [{ max: 10.0, min: 0.0, name: 'x', precision: 0 }] }

    include_examples 'scoring_data_structs'
    include_examples 'reading_formulas'
    include_examples 'answer_tolerance'
    include_examples 'variables'
  end
end
