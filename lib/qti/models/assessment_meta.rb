module Qti
  module Models
    class AssessmentMeta < Qti::Models::Base
      def title
        sanitize_content!(tag_under_quiz('title'))
      end

      def description
        sanitize_content!(tag_under_quiz('description'))
      end

      def shuffle_answers
        tag_under_quiz('shuffle_answers')
      end

      def shuffle_answers?
        string_true?(shuffle_answers)
      end

      def hide_results
        tag_under_quiz('hide_results')
      end

      def scoring_policy
        tag_under_quiz('scoring_policy')
      end

      def quiz_type
        tag_under_quiz('quiz_type')
      end

      def points_possible_raw
        tag_under_quiz('points_possible')
      end

      def points_possible
        points_possible_raw.to_f
      end

      def show_correct_anwers
        tag_under_quiz('show_correct_answers')
      end

      def anonymous_submissions
        tag_under_quiz('anonymous_submissions')
      end

      def anonymous_submissions?
        string_true?(anonymous_submissions)
      end

      def could_be_locked
        tag_under_quiz('could_be_locked')
      end

      def could_be_locked?
        string_true?(could_be_locked)
      end

      def allowed_attempts_raw
        tag_under_quiz('allowed_attempts')
      end

      def allowed_attempts
        allowed_attempts_raw.to_i
      end

      def one_question_at_a_time
        tag_under_quiz('one_question_at_a_time')
      end

      def one_question_at_a_time?
        one_question_at_a_time == 'true'
      end

      def cant_go_back
        tag_under_quiz('cant_go_back')
      end

      def cant_go_back?
        string_true?(cant_go_back)
      end

      def available
        tag_under_quiz('available')
      end

      def available?
        string_true?(available)
      end

      def one_time_results
        tag_under_quiz('one_time_results')
      end

      def one_time_results?
        string_true?(one_time_results)
      end

      def show_correct_answers_last_attempt
        tag_under_quiz('show_correct_answers_last_attempt')
      end

      def show_correct_answers_last_attempt?
        string_true?(show_correct_answers_last_attempt)
      end

      def only_visible_to_overreides
        tag_under_quiz('only_visible_to_overrides')
      end

      def only_visible_to_overrides?
        string_true?(only_visible_to_overrides)
      end

      def module_locked
        tag_under_quiz('module_locked')
      end

      def module_locked?
        string_true?(module_locked)
      end

      def quiz_identifier
        @doc.xpath('//xmlns:quiz/xmlns:assignment/xmlns:quiz_identifierref')&.first&.content
      end

      def lock_at
        tag_under_quiz('lock_at')
      end

      def unlock_at
        tag_under_quiz('unlock_at')
      end

      def due_at
        tag_under_quiz('due_at')
      end

      def access_code
        code = sanitize_content!(tag_under_quiz('access_code'))
        return nil if code.to_s.empty?
        code
      end

      def ip_filter
        tag_under_quiz('ip_filter')
      end

      def time_limit_raw
        tag_under_quiz('time_limit')
      end

      def time_limit
        return nil if time_limit_raw.nil?
        time_limit_raw.to_i
      end

      def show_correct_answers_at
        tag_under_quiz('show_correct_answers_at')
      end

      def hide_correct_answers_at
        tag_under_quiz('hide_correct_answers_at')
      end

      def require_lockdown_browser
        tag_under_quiz('require_lockdown_browser')
      end

      def require_lockdown_browser?
        string_true?(require_lockdown_browser)
      end

      def require_lockdown_browser_for_results
        tag_under_quiz('require_lockdown_browser_for_results')
      end

      def require_lockdown_browser_for_results?
        string_true?(require_lockdown_browser_for_results)
      end

      def require_lockdown_browser_monitor
        tag_under_quiz('require_lockdown_browser_monitor')
      end

      def require_lockdown_browser_monitor?
        string_true?(require_lockdown_browser_monitor)
      end

      def lockdown_browser_monitor_data
        tag_under_quiz('lockdown_browser_monitor_data')
      end

      private

      def tag_under_quiz(tag)
        value = @doc.xpath("//xmlns:quiz/xmlns:#{tag}")&.first&.content
        # If the tag is present but has no content, return nil
        return nil if value.to_s.empty?
        value
      end

      def string_true?(value)
        value&.casecmp('true')&.zero? || false
      end
    end

    module AssessmentMetaBase
      delegate :title, :description,
        :shuffle_answers?, :scoring_policy, :points_possible,
        :hide_results, :quiz_type, :anonymous_submissions?,
        :could_be_locked?, :allowed_attempts, :one_question_at_a_time?,
        :cant_go_back?, :available?, :one_time_results?,
        :show_correct_answers_attempt?, :only_visible_to_overrides?,
        :module_locked?, :access_code, :ip_filter, :time_limit,
        :show_correct_answers_at, :hide_correct_answers_at,
        :lock_at, :unlock_at, :due_at, :require_lockdown_browser?,
        :require_lockdown_browser_for_results?,
        :require_lockdown_browser_monitor?,
        :lockdown_browser_monitor_data,
        to: :@canvas_meta_data, prefix: :canvas, allow_nil: true

      alias canvas_instructions canvas_description

      def canvas_meta_data(meta_data)
        @canvas_meta_data ||= meta_data
      end
    end
  end
end
