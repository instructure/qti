require 'spec_helper'

describe Qti::V2::Models::AssessmentItem do
  context 'choice.xml' do
    let(:fixtures_path) { File.join('spec', 'fixtures') }
    let(:file_path) { File.join(fixtures_path, 'items_2.1', 'choice.xml') }
    let(:loaded_class) { described_class.from_path!(file_path) }

    it 'loads an AssessmentItem XML file' do
      expect do
        described_class.from_path!(file_path)
      end.to_not raise_error
    end

    it 'has the title' do
      expect(loaded_class.title).to eq 'Unattended Luggage'
    end

    it 'has sanitized item_body' do
      expect(loaded_class.item_body).to include '<img'
      expect(loaded_class.item_body).to include '<p'
      expect(loaded_class.item_body).to include 'Look at the text in the picture.'
    end

    it 'falls back onto nil points possible value' do
      expect(loaded_class.points_possible).to eq nil
    end

    it 'grabs the type and scoring data value' do
      struct = loaded_class.send(:scoring_data_structs)
      expect(struct.first.values).to eq 'ChoiceA'
      expect(struct.first.type).to eq 'identifier'
    end

    it 'has the identifier used to identify it in manifest/test files' do
      expect(loaded_class.identifier).to eq 'choice'
    end

    it 'loads the interaction_model without erroring' do
      expect { loaded_class.interaction_model }.not_to raise_error
    end

    it 'loads the correct interaction model' do
      expect(loaded_class.interaction_model).to be_an_instance_of(Qti::V2::Models::Interactions::ChoiceInteraction)
    end
  end

  context 'all test files' do
    test_files = Dir.glob(File.join('spec', 'fixtures', 'items_2.1', '*.xml'))
    test_files.each do |file|
      next if file.include? 'imsmanifest.xml'
      context File.basename(file) do
        let(:loaded_class) { described_class.from_path!(file) }

        it 'loads an AssessmentItem XML file' do
          expect do
            described_class.from_path!(file)
          end.to_not raise_error
        end

        it 'has a title' do
          expect(loaded_class.title).to be_a String
        end
      end
    end
  end
end
