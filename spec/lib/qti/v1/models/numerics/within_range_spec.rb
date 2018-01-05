require 'spec_helper'

describe Qti::V1::Models::Numerics::WithinRange do
  context '#scoring_data' do
    let(:equal_node) { nil }

    let(:gte_node_value) { '1.0' }
    let(:gte_node) do
      double(
        attributes: { 'respident' => double(value: 'response1') },
        content: gte_node_value
      )
    end

    let(:lte_node_value) { '100.0' }
    let(:lte_node) do
      double(
        attributes: { 'respident' => double(value: 'response1') },
        content: lte_node_value
      )
    end

    let(:scoring_node) do
      double(
        equal_node: equal_node,
        gte_node: gte_node,
        lte_node: lte_node
      )
    end

    subject { described_class.new(scoring_node) }

    context 'incompatible nodes' do
      context 'equal_node presents' do
        let(:equal_node) { double(content: '1234') }
        it 'returns nil' do
          expect(subject.scoring_data).to be_nil
        end
      end

      context 'gte_node is missing' do
        let(:gte_node) { nil }
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
      expect(ret_val.type).to eq('withinARange')
      expect(ret_val.start).to eq('1.0')
      expect(ret_val.end).to eq('100.0')
    end
  end
end
