describe Qti::V1::Models::Base do
  context 'specified as single content node matching helpers' do
    let(:loaded_class) do
      fixtures_path = File.join('spec', 'fixtures')
      path = File.join(fixtures_path, 'test_qti_1.2', 'quiz.xml')
      described_class.from_path!(path)
    end

    describe '.sanitize_attributes' do
      it 'respects valid content' do
        source = 'fill in the [blank]'
        expect(loaded_class.sanitize_attributes(source)).to eq source
      end

      it 'translates invalid content' do
        source = '<span title="[x]">fill in the [blank]</span>'
        expected = '<span title="&amp;#91;x&amp;#93;">fill in the [blank]</span>'
        expect(loaded_class.sanitize_attributes(source)).to eq expected
      end
    end
  end
end
