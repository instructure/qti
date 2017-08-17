require 'spec_helper'

describe Qti::V2::Models::Interactions::ShortTextInteraction do
  context 'text_entry.xml' do
    let(:assessment_item) { Qti::V2::Models::AssessmentItem.from_path! 'spec/fixtures/items_2.1/text_entry.xml' }
    subject { assessment_item.interaction_model }

    it { is_expected.to be_an_instance_of(described_class) }

    it 'returns shuffle setting' do
      expect(subject.shuffled?).to eq false
    end

    describe 'matches' do
      it 'raises an exception when the item contains more than 1 <textEntryInteraction>' do
        node = double('Nokogiri::XML::Document')
        matches = [double('Nokogiri::XML::Element'), double('Nokogiri::XML::Element')]
        allow(node).to receive(:xpath).with('.//xmlns:textEntryInteraction').and_return(matches)
        expect{described_class.matches(node, assessment_item)}.to raise_error(Qti::UnsupportedSchema)
      end
    end
  end
end
