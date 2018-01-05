require 'spec_helper'

describe Qti::V1::Models::Numerics::ScoringNode do
  context '#scoring_data' do
    let(:node) { double }

    subject { described_class.new(node) }

    it 'expects node is queried with varequal' do
      expect(node).to receive(:at_xpath).with('.//xmlns:varequal')
      subject.equal_node
    end

    it 'expects node is queried with varequal' do
      expect(node).to receive(:at_xpath).with('.//xmlns:vargte')
      subject.gte_node
    end

    it 'expects node is queried with varequal' do
      expect(node).to receive(:at_xpath).with('.//xmlns:varlte')
      subject.lte_node
    end

    it 'expects node is queried with varequal' do
      expect(node).to receive(:at_xpath).with('.//xmlns:vargt')
      subject.gt_node
    end
  end
end
