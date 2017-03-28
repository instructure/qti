require 'spec_helper'

describe Qti::Importer do
  let(:fixtures_path) { File.join('spec', 'fixtures') }
  let(:importer) { Qti::Importer.new(file_path) }
  let(:manifest_path) { File.join(file_path, 'imsmanifest.xml') }

  shared_examples_for 'initialize' do
    it 'loads an xml file' do
      expect { importer }.to_not raise_error
    end
  end

  shared_examples_for 'unsupported QTI version' do

    it 'raises an error' do
      allow_any_instance_of(Qti::Models::Manifest).to receive(:assessment_test_href).and_return(nil)
      expect { importer.import_manifest }.to raise_error('Unsupported QTI version')
    end
  end

  context 'QTI 1.2' do
    let(:file_path) { File.join(fixtures_path, 'test_qti_1.2') }
    let(:assessment_model) { Qti::V1::Models::Assessment }

    include_examples 'initialize'
    include_examples 'unsupported QTI version'

    describe '#create_assessment_item' do
      it 'create items with correct scoring structs' do
        assessment = importer.test_object
        assessment_items = importer.assessment_item_refs.map{ |ref| importer.create_assessment_item(ref) }
        expect(assessment_items.count).to eq 3
        answer_arity = assessment_items.map{|item| item.scoring_data_structs.count }
        expect(answer_arity).to eq [1, 1, 4]
      end
    end
  end

  context 'QTI 2.1' do
    let(:file_path) { File.join(fixtures_path, 'test_qti_2.2') }
    let(:assessment_model) { Qti::V1::Models::AssessmentTest }

    include_examples 'initialize'
    include_examples 'unsupported QTI version'
  end
end
