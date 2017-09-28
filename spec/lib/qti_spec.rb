require 'spec_helper'

describe Qti::Importer do
  let(:fixtures_path) { File.join('spec', 'fixtures') }
  let(:importer) { Qti::Importer.new(file_path) }
  let(:manifest_path) { File.join(file_path, 'imsmanifest.xml') }

  shared_examples_for 'initialize' do
    it 'loads an xml file' do
      expect { importer }.to_not raise_error
    end

    it 'sets the package root properly' do
      expect(importer.package_root).to eq file_path
    end
  end

  context 'unsupported QTI version' do
    it 'raises an error if the QTI file doesn\'t match expected' do
      file_path = File.join(fixtures_path, 'items_2.1')
      expect { Qti::Importer.new(file_path) }.to raise_error('Unsupported QTI version')
    end

    it 'raises an error if there is no imsmanifest' do
      file_path = File.join(fixtures_path, 'items_1.2')
      expect { Qti::Importer.new(file_path) }.to raise_error('Manifest not found')
    end
  end

  context 'QTI 1.2' do
    let(:file_path) { File.join(fixtures_path, 'test_qti_1.2') }

    include_examples 'initialize'

    describe '#create_assessment_item' do
      it 'create items with correct scoring structs' do
        assessment_items = importer.assessment_item_refs.map { |item| importer.create_assessment_item(item) }
        expect(assessment_items.count).to eq 5
        answer_arity = assessment_items.map { |item| item.scoring_data_structs.count }
        expect(answer_arity).to eq [1, 1, 4, 1, 1]
      end

      it 'sets the path and package root properly' do
        item = importer.create_assessment_item(importer.assessment_item_refs.first)
        expect(item.path).to eq file_path + '/quiz.xml'
        expect(item.package_root).to eq file_path + '/'
      end
    end

    context 'canvas generated' do
      let(:file_path) { File.join(fixtures_path, 'test_qti_1.2_canvas') }

      it 'imports a canvas generated quiz' do
        expect(importer.assessment_item_refs.count).to eq 4
      end
    end
  end

  context 'QTI 2.1' do
    let(:file_path) { File.join(fixtures_path, 'test_qti_2.2') }

    include_examples 'initialize'

    describe '#create_assessment_item' do
      it 'sets the path and package root properly' do
        ref = importer.assessment_item_refs.first
        item = importer.create_assessment_item(ref)
        expect(item.path).to eq ref
        expect(item.package_root).to eq file_path + '/'
        expect(item.manifest).not_to be_nil
      end
    end
  end
end
