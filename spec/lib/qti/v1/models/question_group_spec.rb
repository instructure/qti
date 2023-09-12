describe Qti::V1::Models::QuestionGroup do
  let(:file_path) { File.join('spec', 'fixtures', 'items_1.2', 'question_group.xml') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first) }

  it 'configures a group correctly' do
    expect(loaded_class.title).to eq('Group 1 (1/4)')
    expect(loaded_class.identifier).to eq('i4663897607358cfba8636ed6127b9466')
    expect(loaded_class.sourcebank_ref).to eq('sourcebank_reference_uuid')
    expect(loaded_class.sourcebank_export_id).to eq('sourcebank_export_id_test')
    expect(loaded_class.items.count).to eq(4)
    expect(loaded_class.selection_number).to eq(1)
    expect(loaded_class.points_per_item).to eq(1)
    expect(loaded_class.parent_stimulus_item_ident).to eq('020d8745b74093feb3365745dc18aa0a')
  end
end
