module Qti
  module V1
    module Models
      module Interactions
        class StringInteraction < BaseInteraction
          # This will know if a class matches
          def self.matches(node, parent)
            matches = node.xpath('.//xmlns:render_fib')
            return false if matches.empty?
            new(node, parent)
          end

          def rce
            @rce ||= (rce_raw.nil? || rce_raw.downcase == 'yes')
          end

          def word_count
            @word_count ||= @node.at_xpath('.//xmlns:response_str/@word_count')&.value&.downcase == 'yes'
          end

          def spell_check
            @spell_check ||= @node.at_xpath('.//xmlns:response_str/@spell_check')&.value&.downcase == 'yes'
          end

          def word_limit_enabled
            @word_limit_enabled ||=
              @node.at_xpath('.//xmlns:response_str/@word_limit_enabled')&.value&.downcase == 'yes'
          end

          def word_limit_max
            @word_limit_max ||= @node.at_xpath('.//xmlns:response_str/@word_limit_max')&.value
          end

          def word_limit_min
            @word_limit_min ||= @node.at_xpath('.//xmlns:response_str/@word_limit_min')&.value
          end

          private

          def rcardinality
            @rcardinality ||= @node.at_xpath('.//xmlns:response_str/@rcardinality').value
          end

          def rce_raw
            @rce_raw ||= @node.at_xpath('.//xmlns:response_str/@rce')&.value
          end
        end
      end
    end
  end
end
