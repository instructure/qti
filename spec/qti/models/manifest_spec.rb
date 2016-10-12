require 'spec_helper'

fixtures_path = File.join('spec', 'fixtures')

describe Qti::Models::Manifest do
  manifest_files = Dir.glob(File.join(fixtures_path, '**', 'imsmanifest.xml'))
  manifest_files.each do |file|
    context "File: #{file}" do
      it 'parses the manifest file without error' do
        expect { described_class.from_path!(file) }.not_to raise_error
      end

      it 'returns a path to the xml test reference if it exists' do
        href = described_class.from_path!(file).assessment_test_href
        expect(File.extname(href)).to eq '.xml' if href
      end
    end
  end
end
