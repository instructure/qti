require 'spec_helper'

describe Qti::V1::Models::Numerics::Precision do
  context '#scoring_data' do
    # test case: 0.0123450 with 6 significant digits
    let(:equal_node) do
      double(
        attributes: { 'respident' => double(value: 'response1') },
        content: '0.012345'
      )
    end

    let(:gt_node_value) { '0.01234495' }
    let(:gt_node) do
      double(
        attributes: { 'respident' => double(value: 'response1') },
        content: gt_node_value
      )
    end

    let(:lte_node_value) { '0.01234505' }
    let(:lte_node) do
      double(
        attributes: { 'respident' => double(value: 'response1') },
        content: lte_node_value
      )
    end

    let(:scoring_node) do
      double(
        equal_node: equal_node,
        gt_node: gt_node,
        lte_node: lte_node
      )
    end

    subject { described_class.new(scoring_node) }

    context 'missing node' do
      context 'equal_node is missing' do
        let(:equal_node) { nil }
        it 'returns nil' do
          expect(subject.scoring_data).to be_nil
        end
      end

      context 'gt_node is missing' do
        let(:gt_node) { nil }
        it 'returns nil' do
          expect(subject.scoring_data).to be_nil
        end
      end

      context 'lte_node is missing' do
        let(:lte_node) { nil }
        it 'returns nil' do
          expect(subject.scoring_data).to be_nil
        end
      end
    end

    it 'returns correct attributes' do
      ret_val = subject.scoring_data
      expect(ret_val.id).to eq('response1')
      expect(ret_val.type).to eq('preciseResponse')
      expect(ret_val.value).to eq('0.0123450')
      expect(ret_val.precision).to eq('6')
      expect(ret_val.precision_type).to eq('significantDigits')
    end
  end

  context '#significant_digits' do
    it 'returns correct number for leading zeros' do
      expect(described_class.significant_digits('0.0000123')).
        to eq(3)
    end
    it 'returns correct number for trailing zeros' do
      expect(described_class.significant_digits('0.0000123000')).
        to eq(3)
    end
    it 'returns correct number for zeros in the middle' do
      expect(described_class.significant_digits('0.000012003')).
        to eq(5)
      expect(described_class.significant_digits('15.000012003')).
        to eq(11)
    end
  end
end
