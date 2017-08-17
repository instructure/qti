require 'spec_helper'

describe Qti::V2::Models::Choices::GapMatchChoice do
  context 'choice.xml' do
    let(:item) { double(package_root: 'dummy', path: 'dummy/blah') }
    let(:io) {  File.read(File.join('spec', 'fixtures', 'items_2.1', 'gap_match.xml')) }
    let(:nodes) { Nokogiri::XML(io).xpath('//xmlns:gapText') }

    let(:choices) { nodes.map { |node| described_class.new(node, item) } }

    it 'returns the right identifier' do
      expect(choices.map(&:identifier)).to eq %w(W Sp Su A)
    end

    it 'returns the item body text' do
      expect(choices.map(&:item_body).map(&:empty?).any?).to eq false
    end

    it 'removes inline feedback elements from item_body' do
      expect(choices.map(&:item_body).map { |text| text.include? 'correct' }.any?).to eq false
    end
  end
end
