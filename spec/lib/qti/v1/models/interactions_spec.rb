describe Qti::V1::Models::Assessment do
  describe 'interaction item' do
    let(:fixtures_path) { File.join('spec', 'fixtures') }
    shared_examples_for 'verify interactions' do
      it 'has the correct iinteraction type' do
        loaded_class.assessment_items.zip(expected_item_data).each do |node, itype|
          item = Qti::V1::Models::AssessmentItem.new(node)
          expect(item.interaction_model.class).to eq(itype)
        end
      end
    end

    context 'reference qti 1.2 quiz' do
      let(:path) { File.join(fixtures_path, 'all_canvas_simple_1.2.xml') }
      let(:loaded_class) { described_class.from_path!(path) }
      let(:expected_item_data) do
        [
          Qti::V1::Models::Interactions::ChoiceInteraction,
          Qti::V1::Models::Interactions::ChoiceInteraction,
          Qti::V1::Models::Interactions::FillBlankInteraction,
          Qti::V1::Models::Interactions::FillBlankInteraction,
          Qti::V1::Models::Interactions::ChoiceInteraction,
          Qti::V1::Models::Interactions::CanvasMultipleDropdownInteraction,
          Qti::V1::Models::Interactions::MatchInteraction,
          Qti::V1::Models::Interactions::NumericInteraction,
          Qti::V1::Models::Interactions::FormulaInteraction,
          Qti::V1::Models::Interactions::StringInteraction
        ]
      end
      include_examples('verify interactions')
    end

    context 'reference qti 1.2 quiz with no metadata' do
      let(:path) { File.join(fixtures_path, 'interaction_checks_1.2.xml') }
      let(:loaded_class) { described_class.from_path!(path) }
      let(:expected_item_data) do
        [
          Qti::V1::Models::Interactions::ChoiceInteraction,
          Qti::V1::Models::Interactions::ChoiceInteraction,
          Qti::V1::Models::Interactions::FillBlankInteraction,
          Qti::V1::Models::Interactions::MatchInteraction,
          Qti::V1::Models::Interactions::ChoiceInteraction,
          Qti::V1::Models::Interactions::ChoiceInteraction,
          Qti::V1::Models::Interactions::MatchInteraction,
          Qti::V1::Models::Interactions::NumericInteraction,
          Qti::V1::Models::Interactions::FormulaInteraction,
          Qti::V1::Models::Interactions::StringInteraction
        ]
      end
      include_examples('verify interactions')
    end

    context 'qti 1.2 edge cases' do
      let(:path) { File.join(fixtures_path, 'edge_cases_1.2.xml') }
      let(:loaded_class) { described_class.from_path!(path) }
      let(:expected_item_data) do
        [
          Qti::V1::Models::Interactions::MatchInteraction,
          Qti::V1::Models::Interactions::ChoiceInteraction,
          Qti::V1::Models::Interactions::MatchInteraction,
          Qti::V1::Models::Interactions::ChoiceInteraction
        ]
      end
      include_examples('verify interactions')
    end
  end
end
