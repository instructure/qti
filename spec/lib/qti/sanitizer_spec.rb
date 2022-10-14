describe Qti::Sanitizer do
  let(:sanitizer) { Qti::Sanitizer.new }

  describe '#sanitize' do
    it 'keeps media tags' do
      expect(sanitizer.clean('<img>')).to eq('<img>')
      expect(sanitizer.clean('<video>')).to eq('<video></video>')
      expect(sanitizer.clean('<audio>')).to eq('<audio></audio>')
      expect(sanitizer.clean('<object>')).to eq('<object></object>')
      expect(sanitizer.clean('<embed>')).to eq('<embed>')
    end

    it 'blocks undesirable tags do' do
      expect(sanitizer.clean('<danger>')).to eq('')
    end

    it 'allows needed media src attributes' do
      html = '<audio src="http://a.url" data="B64" type="media" codebase="???">'

      expect(sanitizer.clean(html)).to include 'src'
      expect(sanitizer.clean(html)).to include 'data'
      expect(sanitizer.clean(html)).to include 'type'
      expect(sanitizer.clean(html)).to include 'codebase'
    end

    it 'allows needed media format attributes' do
      html = '<video width="12" height=14 classid="yes">'

      expect(sanitizer.clean(html)).to include 'width'
      expect(sanitizer.clean(html)).to include 'height'
      expect(sanitizer.clean(html)).to include 'classid'
    end

    it 'allows needed media extension attributes' do
      html = '<object data-media-type="thing" data-media-id=123456789>'

      expect(sanitizer.clean(html)).to include 'data-media-type'
      expect(sanitizer.clean(html)).to include 'data-media-id'
    end

    it 'allows needed media alt attributes' do
      html = '<source title="Title" alt="description" allow="fullscreen" allowfullscreen=1>'

      expect(sanitizer.clean(html)).to include 'title'
      expect(sanitizer.clean(html)).to include 'alt'
      expect(sanitizer.clean(html)).to include 'allow'
      expect(sanitizer.clean(html)).to include 'allowfullscreen'
    end
  end
end
