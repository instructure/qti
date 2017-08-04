require 'spec_helper'

describe Qti::Models::Base do
  let(:loaded_class) do
    path = File.join('spec', 'fixtures', 'test_qti_2.2', 'assessment.xml')
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
      it 'constructs a path relative to the basename of the source' do
        expect(loaded_class.remap_href_path('hi.xml')).to eq 'spec/fixtures/test_qti_2.2/hi.xml'
      end

      it 'is not fooled by an absolute href' do
        expect(loaded_class.remap_href_path('/etc/shadow')).to eq 'spec/fixtures/test_qti_2.2/etc/shadow'
      end

      it 'uses an implicit package root' do
        expect {
          loaded_class.remap_href_path('../sneaky.txt')
        }.to raise_error(Qti::ParseError)
      end

      context "with explicit package root" do
        let(:package_root) { File.join('spec', 'fixtures', 'test_qti_2.2') }
        let(:item_path) { File.join(package_root, 'true-false', 'true-false.xml') }
        let(:item) { described_class.from_path!(item_path, package_root) }

        it 'allows safe .. hrefs' do
          expect {
            item.remap_href_path('../okay.txt')
          }.not_to raise_error
        end

        it 'rejects attempts to escape the package' do
          expect {
            item.remap_href_path('../../bad.txt')
          }.to raise_error(Qti::ParseError)
        end
      end

      context "with nil package root" do
        let(:item_path) { File.join('spec', 'fixtures', 'test_qti_2.2', 'true-false', 'true-false.xml') }
        let(:item) { described_class.from_path!(item_path, nil) }

        it 'rejects .. hrefs' do
          expect {
            item.remap_href_path('../no_longer_okay.txt')
          }.to raise_error(Qti::ParseError)
        end
      end
    end
  end
end
