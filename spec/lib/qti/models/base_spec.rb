require 'spec_helper'

describe Qti::Models::Base do
  let(:loaded_class) do
    path = File.join('spec', 'fixtures', 'test_qti_2.1', 'assessment.xml')
    described_class.from_path!(path)
  end

  context 'specified as single content node matching helpers' do
    let(:content_stub) { Struct.new(:content, :thing) }

    # "assessmentItemRef" should match 4 nodes, and therefore raise for these helpers
    let(:bad_xpath) { '//xmlns:assessmentItemRef' }
    let(:bad_css_path) { 'assessmentItemRef' }

    let(:xpath) { '//xmlns:assessmentTest' }
    let(:css_path) { 'assessmentTest' }

    describe '#xpath_with_single_check' do
      it 'raises if node count is more than 1' do
        expect do
          loaded_class.xpath_with_single_check(bad_xpath)
        end.to raise_error(Qti::ParseError)
      end

      it 'doesn\'t raise with a single node count' do
        expect do
          loaded_class.xpath_with_single_check(xpath)
        end.not_to raise_error
      end
    end

    describe '#css_with_single_check' do
      it 'raises if node count is more than 1' do
        expect do
          loaded_class.css_with_single_check(bad_css_path)
        end.to raise_error(Qti::ParseError)
      end

      it 'doesn\'t raise with a single node count' do
        expect do
          loaded_class.css_with_single_check(css_path)
        end.not_to raise_error
      end
    end

    describe '#remap_href_path' do
      let(:href) { 'hi.xml' }
      let(:base_path) { 'hello/bob.xml' }
      let(:remapped_path) { File.join(File.dirname(base_path), href) }
      let(:subject) { loaded_class.remap_href_path(href, base_path) }

      it 'passes the original path if it exists' do
        allow(File).to receive(:exist?).with(href).and_return(true)
        expect(subject).to eq href
      end

      it 'passes the original path when the remapped path doesn\'t exist' do
        allow(File).to receive(:exist?).with(href).and_return(false)
        allow(File).to receive(:exist?).with(remapped_path).and_return(false)
        expect(subject).to eq href
      end

      it 'passes the remapped path if it exists' do
        allow(File).to receive(:exist?).with(href).and_return(false)
        allow(File).to receive(:exist?).with(remapped_path).and_return(true)
        expect(subject).to eq remapped_path
      end
    end
  end
end
