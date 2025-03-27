module Qti
  # rubocop:disable Metrics/ClassLength
  class Sanitizer
    ELEMENTS_REMAP = {
      'prompt' => 'div',
      'simpleBlock' => 'div',
      'simpleInline' => 'span',
      'atomicBlock' => 'div',
      'atomicInline' => 'span'
    }.freeze

    PROTOCOLS = ['http', 'https', :relative].freeze
    FILTER_TAGS = %w[iframe object embed video audio source].freeze
    ALL_DATA_ATTR = [:data].freeze
    MEDIA_SRC_ATTR = %w[src data type codebase].freeze
    MEDIA_FMT_ATTR = %w[width height classid].freeze
    MEDIA_ALT_ATTR = %w[title alt allow allowfullscreen].freeze
    MEDIA_ATTR = [MEDIA_SRC_ATTR, MEDIA_FMT_ATTR, MEDIA_ALT_ATTR, ALL_DATA_ATTR].flatten.freeze

    def self.relaxed_config(element, overrides)
      Sanitize::Config::RELAXED[:attributes][element] + overrides
    end

    # Copied from Canvas (Classic Quizzes)
    # canvas_sanitize/lib/canvas_sanitize/canvas_sanitize.rb:142
    MATHML_TAGS =
      %w[annotation
         annotationml
         maction
         maligngroup
         malignmark
         mark
         math
         menclose
         merror
         mfenced
         mfrac
         mglyph
         mi
         mlabeledtr
         mlongdiv
         mmultiscripts
         mn
         mo
         mover
         mpadded
         mphantom
         mprescripts
         mroot
         mrow
         ms
         mscarries
         mscarry
         msgroup
         msline
         mspace
         msqrt
         msrow
         mstack
         mstyle
         msub
         msubsup
         msup
         mtable
         mtd
         mtext
         mtr
         munder
         munderover
         none
         semantics].freeze

    CONFIG =
      {
        elements: Sanitize::Config::RELAXED[:elements] + MATHML_TAGS + FILTER_TAGS,
        protocols:
          {
            'iframe' => { 'src' => PROTOCOLS },
            'object' => { 'src' => PROTOCOLS, 'data' => PROTOCOLS },
            'embed' => { 'src' => PROTOCOLS },
            'video' => { 'src' => PROTOCOLS },
            'audio' => { 'src' => PROTOCOLS },
            'source' => { 'src' => PROTOCOLS }
          },
        attributes:
          {
            'video' => MEDIA_ATTR,
            'audio' => MEDIA_ATTR,
            'source' => MEDIA_ATTR,
            'object' => MEDIA_ATTR,
            'embed' => %w[name src type allowfullscreen pluginspage wmode
                          allowscriptaccess width height],
            'iframe' => %w[src style width height name align frameborder scrolling sandbox
                           allowfullscreen webkitallowfullscreen mozallowfullscreen
                           allow] + ALL_DATA_ATTR, # TODO: remove explicit allow with domain whitelist account setting
            'a' => relaxed_config('a', ['target'] + ALL_DATA_ATTR),
            'img' => relaxed_config('img', ALL_DATA_ATTR),
            # MathML
            'annotation' => %w[href xref definitionURL encoding cd name src].freeze,
            'annotation-xml' => %w[href xref definitionURL encoding cd name src].freeze,
            'maction' => %w[href xref mathcolor mathbackground actiontype selection].freeze,
            'maligngroup' => %w[href xref mathcolor mathbackground groupalign].freeze,
            'malignmark' => %w[href xref mathcolor mathbackground edge].freeze,
            'map' => ['name'].freeze,
            'math' => %w[href
                         xref
                         display
                         maxwidth
                         overflow
                         altimg
                         altimg-width
                         altimg-height
                         altimg-valign
                         alttext
                         cdgroup
                         mathcolor
                         mathbackground
                         scriptlevel
                         displaystyle
                         scriptsizemultiplier
                         scriptminsize
                         infixlinebreakstyle
                         decimalpoint
                         mathvariant
                         mathsize
                         width
                         height
                         valign
                         form
                         fence
                         separator
                         lspace
                         rspace
                         stretchy
                         symmetric
                         maxsize
                         minsize
                         largeop
                         movablelimits
                         accent
                         linebreak
                         lineleading
                         linebreakstyle
                         linebreakmultchar
                         indentalign
                         indentshift
                         indenttarget
                         indentalignfirst
                         indentshiftfirst
                         indentalignlast
                         indentshiftlast
                         depth
                         lquote
                         rquote
                         linethickness
                         munalign
                         denomalign
                         bevelled
                         voffset
                         open
                         close
                         separators
                         notation
                         subscriptshift
                         superscriptshift
                         accentunder
                         align
                         rowalign
                         columnalign
                         groupalign
                         alignmentscope
                         columnwidth
                         rowspacing
                         columnspacing
                         rowlines
                         columnlines
                         frame
                         framespacing
                         equalrows
                         equalcolumns
                         side
                         minlabelspacing
                         rowspan
                         columnspan
                         edge
                         stackalign
                         charalign
                         charspacing
                         longdivstyle
                         position
                         shift
                         location
                         crossout
                         length
                         leftoverhang
                         rightoverhang
                         mslinethickness
                         selection
                         xmlns].freeze,
            'menclose' => %w[href xref mathcolor mathbackground notation].freeze,
            'merror' => %w[href xref mathcolor mathbackground].freeze,
            'mfenced' => %w[href xref mathcolor mathbackground open close separators].freeze,
            'mfrac' => %w[href
                          xref
                          mathcolor
                          mathbackground
                          linethickness
                          munalign
                          denomalign
                          bevelled].freeze,
            'mglyph' => %w[href xref mathcolor mathbackground src alt width height valign].freeze,
            'mi' => %w[href xref mathcolor mathbackground mathvariant mathsize].freeze,
            'mlabeledtr' => %w[href xref mathcolor mathbackground].freeze,
            'mlongdiv' => %w[href
                             xref
                             mathcolor
                             mathbackground
                             longdivstyle
                             align
                             stackalign
                             charalign
                             charspacing].freeze,
            'mmultiscripts' => %w[href
                                  xref
                                  mathcolor
                                  mathbackground
                                  subscriptshift
                                  superscriptshift].freeze,
            'mn' => %w[href xref mathcolor mathbackground mathvariant mathsize].freeze,
            'mo' => %w[href
                       xref
                       mathcolor
                       mathbackground
                       mathvariant
                       mathsize
                       form
                       fence
                       separator
                       lspace
                       rspace
                       stretchy
                       symmetric
                       maxsize
                       minsize
                       largeop
                       movablelimits
                       accent
                       linebreak
                       lineleading
                       linebreakstyle
                       linebreakmultchar
                       indentalign
                       indentshift
                       indenttarget
                       indentalignfirst
                       indentshiftfirst
                       indentalignlast
                       indentshiftlast].freeze,
            'mover' => %w[href xref mathcolor mathbackground accent align].freeze,
            'mpadded' => %w[href
                            xref
                            mathcolor
                            mathbackground
                            height
                            depth
                            width
                            lspace
                            voffset].freeze,
            'mphantom' => %w[href xref mathcolor mathbackground].freeze,
            'mprescripts' => %w[href xref mathcolor mathbackground].freeze,
            'mroot' => %w[href xref mathcolor mathbackground].freeze,
            'mrow' => %w[href xref mathcolor mathbackground].freeze,
            'ms' => %w[href xref mathcolor mathbackground mathvariant mathsize lquote rquote].freeze,
            'mscarries' => %w[href
                              xref
                              mathcolor
                              mathbackground
                              position
                              location
                              crossout
                              scriptsizemultiplier].freeze,
            'mscarry' => %w[href xref mathcolor mathbackground location crossout].freeze,
            'msgroup' => %w[href xref mathcolor mathbackground position shift].freeze,
            'msline' => %w[href
                           xref
                           mathcolor
                           mathbackground
                           position
                           length
                           leftoverhang
                           rightoverhang
                           mslinethickness].freeze,
            'mspace' => %w[href xref mathcolor mathbackground mathvariant mathsize].freeze,
            'msqrt' => %w[href xref mathcolor mathbackground].freeze,
            'msrow' => %w[href xref mathcolor mathbackground position].freeze,
            'mstack' => %w[href
                           xref
                           mathcolor
                           mathbackground
                           align
                           stackalign
                           charalign
                           charspacing].freeze,
            'mstyle' => %w[href
                           xref
                           mathcolor
                           mathbackground
                           scriptlevel
                           displaystyle
                           scriptsizemultiplier
                           scriptminsize
                           infixlinebreakstyle
                           decimalpoint
                           mathvariant
                           mathsize
                           width
                           height
                           valign
                           form
                           fence
                           separator
                           lspace
                           rspace
                           stretchy
                           symmetric
                           maxsize
                           minsize
                           largeop
                           movablelimits
                           accent
                           linebreak
                           lineleading
                           linebreakstyle
                           linebreakmultchar
                           indentalign
                           indentshift
                           indenttarget
                           indentalignfirst
                           indentshiftfirst
                           indentalignlast
                           indentshiftlast
                           depth
                           lquote
                           rquote
                           linethickness
                           munalign
                           denomalign
                           bevelled
                           voffset
                           open
                           close
                           separators
                           notation
                           subscriptshift
                           superscriptshift
                           accentunder
                           align
                           rowalign
                           columnalign
                           groupalign
                           alignmentscope
                           columnwidth
                           rowspacing
                           columnspacing
                           rowlines
                           columnlines
                           frame
                           framespacing
                           equalrows
                           equalcolumns
                           side
                           minlabelspacing
                           rowspan
                           columnspan
                           edge
                           stackalign
                           charalign
                           charspacing
                           longdivstyle
                           position
                           shift
                           location
                           crossout
                           length
                           leftoverhang
                           rightoverhang
                           mslinethickness
                           selection].freeze,
            'msub' => %w[href xref mathcolor mathbackground subscriptshift].freeze,
            'msubsup' => %w[href xref mathcolor mathbackground subscriptshift superscriptshift].freeze,
            'msup' => %w[href xref mathcolor mathbackground superscriptshift].freeze,
            'mtable' => %w[href
                           xref
                           mathcolor
                           mathbackground
                           align
                           rowalign
                           columnalign
                           groupalign
                           alignmentscope
                           columnwidth
                           width
                           rowspacing
                           columnspacing
                           rowlines
                           columnlines
                           frame
                           framespacing
                           equalrows
                           equalcolumns
                           displaystyle
                           side
                           minlabelspacing].freeze,
            'mtd' => %w[href
                        xref
                        mathcolor
                        mathbackground
                        rowspan
                        columnspan
                        rowalign
                        columnalign
                        groupalign].freeze,
            'mtext' => %w[href
                          xref
                          mathcolor
                          mathbackground
                          mathvariant
                          mathsize
                          width
                          height
                          depth
                          linebreak].freeze,
            'mtr' => %w[href xref mathcolor mathbackground rowalign columnalign groupalign].freeze,
            'munder' => %w[href xref mathcolor mathbackground accentunder align].freeze,
            'munderover' => %w[href xref mathcolor mathbackground accent accentunder align].freeze,
            'none' => %w[href xref mathcolor mathbackground].freeze,
            'semantics' => %w[href xref definitionURL encoding].freeze
          }
      }.freeze

    def clean(html)
      Sanitize.fragment(html, sanitize_config)
    end

    private

    def convert_canvas_math_images(env)
      node = env[:node]
      node_name = env[:node_name]
      latex = node['data-equation-content']

      return if env[:is_whitelisted] || !env[:node].element?
      return unless node_name == 'img'
      return unless latex

      node.replace("\\(#{latex}\\)")
    end

    def object_tag_transformer
      lambda do |env|
        return unless env[:node_name] == 'object'
        return if env[:is_whitelisted] || !env[:node].element?
        replace_object_node(env[:node])
      end
    end

    def remap_unknown_tags_transformer
      lambda do |env|
        node_name = env[:node_name]
        node = env[:node]

        return if env[:is_whitelisted] || !node.element?
        return unless ELEMENTS_REMAP.keys.include? node_name

        new_name = ELEMENTS_REMAP[node_name]
        env[:node].name = new_name
        env[:node_name] = new_name
      end
    end

    def src_transformers
      lambda do |env|
        return unless FILTER_TAGS.include?(env[:node_name])
        return if env[:is_whitelisted] || !env[:node].element?
        Sanitize.node!(env[:node], Sanitize::Config.merge(Sanitize::Config::RELAXED, CONFIG))
        { node_whitelist: [env[:node]] }
      end
    end

    def sanitize_config(import_objects: true)
      transformers = []
      transformers << src_transformers
      transformers << object_tag_transformer if import_objects
      transformers << remap_unknown_tags_transformer
      transformers << method(:convert_canvas_math_images) if Qti.configuration.extract_latex_from_image_tags
      Sanitize::Config.merge(
        Sanitize::Config.merge(Sanitize::Config::RELAXED, CONFIG),
        transformers: transformers
      )
    end

    def remap_href_path(href)
      return nil unless href
      path = File.join(File.dirname(@path), href)
      if @package_root.nil?
        raise Qti::ParseError, "Potentially unsafe href '#{href}'" if href.split('/').include?('..')
      else
        unless Pathname.new(path).cleanpath.to_s.start_with?(@package_root)
          raise Qti::ParseError, "Unsafe href '#{href}'"
        end
      end
      path
    end

    def replace_object_node(node)
      path = remap_href_path(node[:data])
      if path
        case node[:type]
        when %r{^image/}
          return replace_with_image(node, node[:data])
        when 'text/html'
          return replace_with_html(node, path)
        end
      end
      # remove unrecognized or invalid objects from the sanitized document
      node.unlink
    end

    def replace_with_image(node, src)
      node.name = 'img'
      node[:src] = src
    end

    def replace_with_html(node, path)
      content = File.read(path)
      html_content = Sanitize.fragment(content, sanitize_config(import_objects: false))
      node.name = 'div'
      node.add_child(Nokogiri::HTML.fragment(html_content))
    rescue StandardError => e
      warn "failed to import html object #{path}: #{e.message}"
      node.unlink
    end
  end
  # rubocop:enable Metrics/ClassLength
end
