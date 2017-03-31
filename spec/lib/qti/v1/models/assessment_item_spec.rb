require 'spec_helper'

describe Qti::V1::Models::AssessmentItem do
  context 'quiz.xml' do
    let(:file_path) { File.join('spec', 'fixtures', 'items_1.2', 'true_false.xml') }
    let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
    let(:assessment_item_refs) { test_object.assessment_items }
    let(:loaded_class) { described_class.new(assessment_item_refs) }

    it 'loads an AssessmentItem ref' do
      expect do
        described_class.new(assessment_item_refs)
      end.to_not raise_error
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

    describe '#scoring_data_structs' do
      it 'grabs the rcardinality and scoring data value' do
        struct = loaded_class.send(:scoring_data_structs)
        expect(struct.first.values).to eq 'QUE_1006_A2'
        expect(struct.first.rcardinality).to eq 'Single'
      end

      it 'grabs scoring data value for ordering questions' do
        assessment = Qti::V1::Models::Assessment.from_path! 'spec/fixtures/items_1.2/ordering.xml'
        assessment_item = described_class.new(assessment.assessment_items.first)
        expect(assessment_item.scoring_data_structs.count).to eq 1
        expect(assessment_item.scoring_data_structs.first.values).to eq %w(A B E D C)
      end

      it 'grabs scoring data value for matching questions' do
        assessment = Qti::V1::Models::Assessment.from_path! 'spec/fixtures/items_1.2/matching.xml'
        assessment_item = described_class.new(assessment.assessment_items.first)
        expect(assessment_item.interaction_model.questions).to eq(
          [{ id: 'question_1', question_body: 'Light Microscope' },
           { id: 'question_2', question_body: 'Electron Microscopes' }]
        )
        expect(assessment_item.scoring_data_structs.first.values).to eq(
          'question_1' => 'Magnify up to about 400 times. Sometimes requires colored staining of cells.',
          'question_2' => "Uses a beam of electrons. Can provide details of cells' internal structure."
        )
        expect(assessment_item.interaction_model.answers.map(&:item_body)).to eq(
          ['Magnify up to about 400 times. Sometimes requires colored staining of cells.',
           "Uses a beam of electrons. Can provide details of cells' internal structure.",
           'A distractor answer.']
        )
      end
    end

    it 'has the identifier used to identify it in manifest/test files' do
      expect(loaded_class.identifier).to eq 'QUE_1003'
    end

    it 'loads the interaction_model without erroring' do
      expect { loaded_class.interaction_model }.not_to raise_error
    end

    it 'loads the correct interaction model' do
      expect(loaded_class.interaction_model).to be_an_instance_of(
        Qti::V1::Models::Interactions::ChoiceInteraction
      )
    end
  end
end
