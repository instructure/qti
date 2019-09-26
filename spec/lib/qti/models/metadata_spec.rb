fixtures_path = File.join('spec', 'fixtures')

describe Qti::Models::Manifest do
  shared_examples 'metadata with empty or no taxonpaths' do
    it 'will have metadata attached' do
      expect(testobject.metadata).not_to eq(nil)
    end

    it 'will not contain any taxonpaths' do
      expect(testobject.metadata.taxonpaths).to eq(nil)
    end
  end

  describe 'v1 assessment_tests' do
    qti1_files = ['test_qti_1.2', 'test_qti_1.2_canvas']
    qti1_files.each do |qfile|
      let(:file) { File.join(fixtures_path, qfile, 'imsmanifest.xml') }
      let(:testobject) { described_class.from_path!(file).assessment_test }

      include_examples 'metadata with empty or no taxonpaths'
    end
  end

  describe 'v2 assessment_tests' do
    qti2_files = ['test_qti_2.1', 'test_qti_2.2']
    qti2_files.each do |qfile|
      let(:file) { File.join(fixtures_path, qfile, 'imsmanifest.xml') }
      let(:testobject) { described_class.from_path!(file).assessment_test }

      include_examples 'metadata with empty or no taxonpaths'
    end
  end

  describe 'canvas cartridge' do
    let(:file) { File.join(fixtures_path, 'canvas_cartridge/imsmanifest.xml') }
    let(:testobject) { described_class.from_path!(file).assessment_test }

    include_examples 'metadata with empty or no taxonpaths'
  end

  describe 'v2 non assessment' do
    let(:file) { File.join(fixtures_path, 'no_assessment_xml/imsmanifest.xml') }
    let(:assessment_test) { described_class.from_path!(file).assessment_test }
    let(:testobject) { assessment_test.assessment_items.first[:resource] }

    include_examples 'metadata with empty or no taxonpaths'
  end

  describe 'v2 assessment with taxonpaths' do
    let(:file) { File.join(fixtures_path, 'test_qti_2.1_taxonpath/imsmanifest.xml') }
    let(:assessment_test) { described_class.from_path!(file).assessment_test }
    let(:testobject) { assessment_test.assessment_items.last[:resource] }

    it 'will have metadata' do
      expect(testobject.metadata).not_to eq(nil)
    end

    it 'will contain taxonpaths' do
      expect(testobject.metadata.taxonpaths.count).to eq(5)
    end

    describe 'taxonpath instances' do
      let(:taxonpath) { testobject.metadata.taxonpaths }

      it 'accepts sources with empty taxons' do
        expect(taxonpath['Blank Entry']['default']).to eq([''])
      end

      it 'accepts sources with a single entry' do
        expect(taxonpath['Single Entry']['default']).to eq(['Data'])
      end

      it 'accepts sources with nested entries' do
        expect(taxonpath['Nested Entry']['default']).to eq(['Level 1', 'Level 2', 'Level 3'])
      end

      it 'is agnostic about string and langstring' do
        expect(taxonpath['String Type']['default']).to eq(%w[langstring string])
      end

      it 'allows for multiple languages in entries' do
        expect(taxonpath['Language Entry']['default']).to eq(['Default'])
        expect(taxonpath['Language Entry']['en']).to eq(['English'])
        expect(taxonpath['Language Entry']['de']).to eq(['Deutsch'])
        expect(taxonpath['Language Entry']['fr']).to eq(['French'])
        expect(taxonpath['Language Entry']['ja']).to eq(['Japanese'])
        expect(taxonpath['Language Entry']['hr']).to eq(['Croatian'])
        expect(taxonpath['Language Entry']['hu']).to eq(['Hungarian'])
      end
    end
  end
end
