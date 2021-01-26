describe Qti::Models::Base do
  context 'specified as single content node matching helpers' do
    let(:loaded_class) do
      path = File.join('spec', 'fixtures', 'test_qti_2.2', 'assessment.xml')
      described_class.from_path!(path)
    end

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
        expect do
          loaded_class.remap_href_path('../sneaky.txt')
        end.to raise_error(Qti::ParseError)
      end

      describe 'sanitize of href/src in html' do
        let(:ftp) { 'ftp://foo.bar/' }
        let(:http) { 'http://foo.bar/' }
        let(:https) { 'https://foo.bar' }
        let(:closing_tag) { true }

        shared_examples_for 'specific html elements' do
          it 'removes a src with a bad protocol' do
            ftp_tag = "<#{tag_name} #{src_attr}=\"#{ftp}\">"
            ftp_tag += "</#{tag_name}>" if closing_tag
            expected_tag = "<#{tag_name}>"
            expected_tag += "</#{tag_name}>" if closing_tag
            expect(loaded_class.sanitize_content!(ftp_tag)).to eq(expected_tag)
          end

          it 'removes a src with a valid http protocol' do
            http_tag = "<#{tag_name} #{src_attr}=\"#{http}\">"
            http_tag += "</#{tag_name}>" if closing_tag
            expect(loaded_class.sanitize_content!(http_tag)).to eq(http_tag)
          end

          it 'removes a src with a valid https protocol' do
            https_tag = "<#{tag_name} #{src_attr}=\"#{https}\">"
            https_tag += "</#{tag_name}>" if closing_tag
            expect(loaded_class.sanitize_content!(https_tag)).to eq(https_tag)
          end
        end

        describe 'embed elements' do
          let(:tag_name) { 'embed' }
          let(:src_attr) { 'src' }
          let(:closing_tag) { false }

          include_examples('specific html elements')
        end

        describe 'iframe elements' do
          let(:tag_name) { 'iframe' }
          let(:src_attr) { 'src' }

          include_examples('specific html elements')
        end

        describe 'object elements with data' do
          let(:tag_name) { 'object' }
          let(:src_attr) { 'data' }

          include_examples('specific html elements')
        end

        describe 'object elements with src' do
          let(:tag_name) { 'object' }
          let(:src_attr) { 'src' }

          include_examples('specific html elements')
        end
      end

      context 'with explicit package root' do
        let(:package_root) { File.join('spec', 'fixtures', 'test_qti_2.2') }
        let(:item_path) { File.join(package_root, 'true-false', 'true-false.xml') }
        let(:item) { described_class.from_path!(item_path, package_root: package_root) }

        it 'allows safe .. hrefs' do
          expect do
            item.remap_href_path('../okay.txt')
          end.not_to raise_error
        end

        it 'rejects attempts to escape the package' do
          expect do
            item.remap_href_path('../../bad.txt')
          end.to raise_error(Qti::ParseError)
        end
      end

      context 'with nil package root' do
        let(:item_path) { File.join('spec', 'fixtures', 'test_qti_2.2', 'true-false', 'true-false.xml') }
        let(:item) { described_class.from_path!(item_path, package_root: nil) }

        it 'rejects .. hrefs' do
          expect do
            item.remap_href_path('../no_longer_okay.txt')
          end.to raise_error(Qti::ParseError)
        end
      end
    end
  end

  context 'preprocessing' do
    let(:loaded_class) do
      path = File.join('spec', 'fixtures', 'mathml', 'numeric_1.2.xml')
      described_class.from_path!(path)
    end
    let(:expected_latex) { '\\(\\frac{1}{2}\\times \\sqrt[10]{379}\\)' }

    it 'replaces any mathml block' do
      obj = loaded_class
      expect(obj.instance_variable_get('@doc').to_s).to include(expected_latex)
    end
  end
end
