require 'spec_helper'

describe Qti::V2::Models::Choices::SimpleAssociableChoice do
  let(:io) { File.read('spec/fixtures/items_2.1/match2.xml') }
  let(:nodes) { Nokogiri::XML(io).xpath('//xmlns:simpleAssociableChoice') }
  let(:choices) { nodes.map { |node| described_class.new(node) } }

  it 'returns the expected attributes' do
    expected_attrs = [
      %w(Match28433682 1 1 Weißeritz),
      %w(Match7191791 1 1 Mulde),
      %w(Match20473010 1 1 Saale),
      %w(Match6429655 1 1 Spree),
      %w(Match2675678 1 1 Dresden),
      %w(Match9372581 1 1 Leipzig),
      %w(Match22744006 1 1 Halle),
      %w(Match17943221 1 1 Bautzen)
    ]
    expect(choices.map { |c| [c.identifier, c.match_min, c.match_max, c.item_body] }).to eq expected_attrs
  end
end
