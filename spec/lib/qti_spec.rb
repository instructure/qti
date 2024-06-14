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
      file_path = File.join(fixtures_path, 'unsupported_version')
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
        expect(answer_arity).to eq [2, 5, 7, 1, 1]
      end

      it 'sets the path and package root properly' do
        item = importer.create_assessment_item(importer.assessment_item_refs.first)
        expect(item.path).to eq "#{file_path}/quiz.xml"
        expect(item.package_root).to eq "#{file_path}/"
      end
    end

    describe '#create_bank_entry_item' do
      context 'when given a bankentry_item object' do
        let(:file_path) { File.join(fixtures_path, 'test_qti_1.2_bank_entry_item') }

        it 'creates a bankentry_item instance' do
          bank_entry_item = importer.create_bank_entry_item(importer.assessment_item_refs.first)
          expect(bank_entry_item).to be_a(Qti::V1::Models::BankEntryItem)
        end
      end

      context 'when given an object other than a bankentry_item' do
        let(:file_path) { File.join(fixtures_path, 'test_qti_1.2') }

        it 'returns nil' do
          bank_entry_item = importer.create_bank_entry_item(importer.assessment_item_refs.first)
          expect(bank_entry_item).to be_nil
        end
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
        expect(item.path).to eq ref[:path]
        expect(item.package_root).to eq "#{file_path}/"
        expect(item.manifest).not_to be_nil
      end
    end
  end

  context 'QTI file contianing Multiple Assessments' do
    let(:assessment_list) { Qti::Importer.assessment_identifiers_for(file_path) }
    let(:importer) { Qti::Importer.new(file_path, assessment_id) }
    let(:assessment_ids) { %w[ife643a8a04b48b22acab95de6c01f1cc i913965373124f56ca136e87deb040c03] }

    shared_examples_for 'quiz instance' do
      it 'loads the correct quiz' do
        expect(importer.assessment_id).to eq(assessment_id)
        expect(importer.test_object.title).to eq(expected_quiz_title)
      end
    end

    shared_examples_for 'the course container' do
      it 'can get a list of available assessments' do
        expect(assessment_list.count).to eq(2)
        expect(assessment_list).to eq(assessment_ids)
      end

      describe 'importing first assessment' do
        let(:assessment_id) { 'ife643a8a04b48b22acab95de6c01f1cc' }
        let(:expected_quiz_title) { 'Quiz #1' }

        include_examples 'quiz instance'
      end

      describe 'importing second assessment' do
        let(:assessment_id) { 'i913965373124f56ca136e87deb040c03' }
        let(:expected_quiz_title) { 'Quiz #2' }

        include_examples 'quiz instance'
      end
    end

    describe 'as a QTI file' do
      let(:file_path) { File.join(fixtures_path, 'test_qti_1.2_multi') }

      include_examples 'the course container'
    end

    describe 'as a Common Cartridge file' do
      let(:file_path) { File.join(fixtures_path, 'test_imscc_canvas') }

      include_examples 'the course container'
    end
  end
end
