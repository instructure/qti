module Qti
  module XPathHelpers
    def xpath_resource(type = '')
      "//xmlns:resources/xmlns:resource#{type}"
    end

    def xpath_endswith(tag, tail)
      "substring(#{tag}, string-length(#{tag}) - string-length('#{tail}') + 1) = '#{tail}'"
    end

    def rtype_predicate(ver, rsc_type)
      # XPath 2.0 supports ends-with, which is what substring is doing here.
      # It also support regex matching with matches.
      # We only have XPath 1.0 available.
      cc_match = "starts-with(@type, '#{ver}') and " + xpath_endswith('@type', rsc_type)
      qti_match = "@type='#{ver}'"
      "#{qti_match} or (#{cc_match})"
    end
  end
end
