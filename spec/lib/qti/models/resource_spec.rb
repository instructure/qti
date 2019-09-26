fixtures_path = File.join('spec', 'fixtures')

describe Qti::Models::Manifest do
  manifest_files = ['test_qti_1.2', 'test_qti_1.2_canvas', 'test_qti_2.1', 'test_qti_2.2']
  manifest_files.each do |mfile|
    file = File.join(fixtures_path, mfile, 'imsmanifest.xml')
    context "File: #{file}" do
      it 'parses the manifest file without error' do
        expect { described_class.from_path!(file) }.not_to raise_error
      end
    end
  end

  it 'v1 assessment_tests have a resource attached' do
    qti1_files = ['test_qti_1.2', 'test_qti_1.2_canvas']
    qti1_files.each do |qfile|
      file = File.join(fixtures_path, qfile, 'imsmanifest.xml')
      assessment_test = described_class.from_path!(file).assessment_test
      expect(assessment_test.resource).not_to eq(nil)
    end
  end

  it 'v2 assessment_tests have a resource attached' do
    qti2_files = ['test_qti_2.1', 'test_qti_2.2']
    qti2_files.each do |qfile|
      file = File.join(fixtures_path, qfile, 'imsmanifest.xml')
      assessment_test = described_class.from_path!(file).assessment_test
      expect(assessment_test.resource).not_to eq(nil)
    end
  end

  it 'canvas cartridge have canvas metadata attached to the resource' do
    file = File.join(fixtures_path, 'canvas_cartridge/imsmanifest.xml')
    assessment_test = described_class.from_path!(file).assessment_test
    expect(assessment_test.resource).not_to eq(nil)
    expect(assessment_test.resource.canvas_metadata).not_to eq(nil)
  end

  describe 'v2 non assessment' do
    file = File.join(fixtures_path, 'no_assessment_xml/imsmanifest.xml')
    assessment_test = described_class.from_path!(file).assessment_test

    it 'will not have a resource attached' do
      expect(assessment_test.resource).to eq(nil)
    end

    it 'the assessment_items will have resources attached' do
      expect(assessment_test.assessment_items.first[:resource]).not_to eq(nil)
    end
  end
end
