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

    it 'allows needed media alt attributes' do
      html = '<source title="Title" alt="description" allow="fullscreen" allowfullscreen=1>'

      expect(sanitizer.clean(html)).to include 'title'
      expect(sanitizer.clean(html)).to include 'alt'
      expect(sanitizer.clean(html)).to include 'allow'
      expect(sanitizer.clean(html)).to include 'allowfullscreen'
    end

    it 'allows data attributes on <img>, <object>, <video>, <audio>, <iframe>, <source>, <a>' do
      %w[<img> <object> <video> <audio> <iframe> <source> <a>].each do |tag|
        tag.insert(-2, ' data-test="thing" data-media-id=123456789')

        expect(sanitizer.clean(tag)).to include 'data-test'
        expect(sanitizer.clean(tag)).to include 'data-media-id'
      end
    end

    it 'allows target attribute on <a>' do
      html = '<a href="http://a.url" target="_blank">'

      expect(sanitizer.clean(html)).to include 'target="_blank"'
    end

    it 'allows style attributes on iframe' do
      html = '<iframe style="width: 523px; height: 294px; display: inline-block;"></iframe>'

      expect(sanitizer.clean(html)).to include 'style'
      expect(sanitizer.clean(html)).to include 'width: 523px;'
      expect(sanitizer.clean(html)).to include 'height: 294px;'
      expect(sanitizer.clean(html)).to include 'display: inline-block;'
    end
  end
end
