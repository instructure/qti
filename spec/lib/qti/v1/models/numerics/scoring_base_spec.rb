describe Qti::V1::Models::Numerics::ScoringBase do
  let(:scoring_node) { double }

  subject { described_class.new(scoring_node) }

  describe '#equal_node' do
    it 'fetches equal_node' do
      expect(scoring_node).to receive(:equal_node)
      subject.equal_node
    end
  end

  describe '#gte_node' do
    it 'fetches gte_node' do
      expect(scoring_node).to receive(:gte_node)
      subject.gte_node
    end
  end

  describe '#lte_node' do
    it 'fetches lte_node' do
      expect(scoring_node).to receive(:lte_node)
      subject.lte_node
    end
  end

  describe '#gt_node' do
    it 'fetches gt_node' do
      expect(scoring_node).to receive(:gt_node)
      subject.gt_node
    end
  end
end
