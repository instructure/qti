require 'spec_helper'

describe Qti::V2::Models::Interactions::MatchInteraction do
  let(:file) { File.read(File.join('spec', 'fixtures', 'items_2.1', 'match.xml')) }
  let(:node) { Nokogiri::XML(file) }
  subject { described_class.new(node) }

  it 'returns shuffle setting' do
    expect(subject.shuffled?).to eq true
  end

  it 'returns the answers' do
    expect(subject.answers.map(&:item_body)).to eq ["A Midsummer-Night's Dream", 'Romeo and Juliet', 'The Tempest']
  end
end
