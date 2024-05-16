describe Qti::V1::Models::ObjectBank do
  let(:doc) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <questestinterop xmlns="http://www.imsglobal.org/xsd/ims_qtiasiv1p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd">
        <objectbank ident="gooblegobble12345" canvas_item_bank="true">
          <qtimetadata>
            <qtimetadatafield>
              <fieldlabel>not_a_bank_title</fieldlabel>
              <fieldentry>A different metadata entry</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>bank_type</fieldlabel>
              <fieldentry>account</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>bank_context_uuid</fieldlabel>
              <fieldentry>oAORQgMEvQquzZyKIW6Usg6CFveihQH5pOqHadsb</fieldentry>
            </qtimetadatafield>
          </qtimetadata>
        </objectbank>
      </questestinterop>
    XML
  end

  describe 'bank loading' do
    [
      'gf3edf8167be16b3a65a00ca923132b07.xml.qti',
      'g195e078fb6e3c4054e38e5c9226287ba.xml.qti',
      'gab22de457404cb5cf022078f1e4da75e.xml.qti'
    ].each do |bankfile|
      file = File.join('spec', 'fixtures', 'with_banks', 'non_cc_assessments', bankfile)
      context "File: #{file}" do
        it 'parses the objectbank without error' do
          expect do
            bank = described_class.from_path!(file)
            expect(bank.assessment_items) # at least one
          end.not_to raise_error
        end
      end
    end
  end

  describe '#title' do
    it 'missing bank_title defaults to filename' do
      allow(File).to receive(:read).and_return(doc)
      objectbank = described_class.new path: '/etc/FakeBank007.xml'
      expect(objectbank.title).to eq 'FakeBank007'
    end
  end

  describe '#identifier' do
    it 'has the identifier attribute' do
      allow(File).to receive(:read).and_return(doc)
      objectbank = described_class.new path: '/etc/FakeBank008.xml'
      expect(objectbank.identifier).to eq 'gooblegobble12345'
    end
  end

  describe '#canvas_item_bank' do
    it 'returns the canvas_item_bank' do
      allow(File).to receive(:read).and_return(doc)
      objectbank = described_class.new path: '/etc/FakeBank008.xml'
      expect(objectbank.canvas_item_bank).to eq 'true'
    end
  end

  describe '#bank_type' do
    it 'has the bank_type attribute' do
      allow(File).to receive(:read).and_return(doc)
      objectbank = described_class.new path: '/etc/FakeBank008.xml'
      expect(objectbank.bank_type).to eq 'account'
    end
  end

  describe '#bank_context_uuid' do
    it 'has the bank_context_uuid attribute' do
      allow(File).to receive(:read).and_return(doc)
      objectbank = described_class.new path: '/etc/FakeBank008.xml'
      expect(objectbank.bank_context_uuid).to eq 'oAORQgMEvQquzZyKIW6Usg6CFveihQH5pOqHadsb'
    end
  end
end
