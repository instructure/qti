require 'spec_helper'

describe Qti::V1::Models::AssessmentItem do
  context 'quiz.xml' do
    let(:file_path) { File.join('spec', 'fixtures', 'items_1.2', 'true_false.xml') }
    let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
    let(:assessment_item_refs) { test_object.assessment_items }
    let(:loaded_class) { described_class.new(assessment_item_refs) }

    it 'loads an AssessmentItem ref' do
      expect do
        described_class.new(assessment_item_ref)
      end.to_not raise_error(Qti::ParseError)
    end

    it 'has the title' do
      expect(loaded_class.title).to eq 'Grading - specific - 3 pt score'
    end

    it 'has sanitized item_body' do
      expect(loaded_class.item_body).to include '<img'
      expect(loaded_class.item_body).to include 'If I get a 3, I must have done something wrong.'
    end

    it 'grabs the points possible' do
      expect(loaded_class.points_possible).to eq '0'
    end

    it 'grabs the rcardinality and scoring data value' do
      struct = loaded_class.send(:scoring_data_structs)
      expect(struct.first.values).to eq 'QUE_1005_A1'
      expect(struct.first.rcardinality).to eq 'Single'
    end

    it 'has the identifier used to identify it in manifest/test files' do
      expect(loaded_class.identifier).to eq 'QUE_1003'
    end

    it 'loads the interaction_model without erroring' do
      expect { loaded_class.interaction_model }.not_to raise_error
    end

    it 'loads the correct interaction model' do
      expect(loaded_class.interaction_model).to be_an_instance_of(
        Qti::V1::Models::Interactions::LogicalIdentifierInteraction
      )
    end
  end
end
