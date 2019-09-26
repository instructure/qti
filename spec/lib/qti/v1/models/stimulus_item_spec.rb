describe Qti::V1::Models::StimulusItem do
  let(:ref_node) { double }
  let(:attrs) do
    {
      'ident' => Struct.new(:value).new('aaaa'),
      'title' => Struct.new(:value).new('tttt')
    }
  end
  let(:loaded_class) { described_class.new(ref_node) }

  before do
    allow(ref_node).to receive(:attributes).and_return(attrs)
  end

  context '#body' do
    context 'presentation node does not exist' do
      before do
        expect(ref_node).to receive(:at_xpath).and_return(nil)
      end

      it 'returns nil' do
        expect(loaded_class.body).to be_nil
      end
    end

    context 'presentation node does not exist' do
      let(:presentation) { double }
      let(:mattext) { double }

      before do
        expect(ref_node).to receive(:at_xpath).and_return(presentation)
        expect(presentation).to receive(:at_xpath).and_return(mattext)
        expect(mattext).to receive(:text).and_return('1234')
      end

      it 'returns nil' do
        expect(loaded_class.body).to eq('1234')
      end
    end
  end

  it 'returns correct title' do
    expect(loaded_class.title).to eq('tttt')
  end

  it 'returns correct identifier' do
    expect(loaded_class.identifier).to eq('aaaa')
  end

  it 'returns correct stimulus_type' do
    expect(loaded_class.stimulus_type).to eq('text')
  end
end
