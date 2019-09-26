describe Qti::V2::Models::Interactions::ChoiceInteraction do
  context 'choice.xml' do
    let(:item) { double(package_root: 'dummy', path: 'dummy/blah') }
    let(:io) { File.read(File.join('spec', 'fixtures', 'items_2.1', 'choice.xml')) }
    let(:node) { Nokogiri::XML(io).at_xpath('//xmlns:choiceInteraction') }

    let(:loaded_class) { described_class.new(node, item) }

    it 'returns shuffle setting' do
      expect(loaded_class.shuffled?).to eq true
    end

    it 'returns the max choices count' do
      expect(loaded_class.max_choices_count).to eq 1
    end

    it 'returns the min choices without error' do
      expect(loaded_class.min_choices_count).to eq nil
    end

    it 'returns the answers' do
      expect(loaded_class.answers.count).to eq 3
      expect(loaded_class.answers.first).to be_an_instance_of(Qti::V2::Models::Choices::SimpleChoice)
    end
  end
end
