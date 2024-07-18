context 'Canvas Assessment Meta Data' do
  let(:fixtures_path) { File.join('spec', 'fixtures') }
  let(:file_path) { File.join(fixtures_path, qti_file) }
  let(:assessment) { Qti::Importer.new(file_path).test_object }

  shared_examples 'loads canvas meta data' do
    it 'creates a valid assessment' do
      expect(assessment).to be_kind_of(assessment_type)
      expect(assessment.canvas_title).to eq(title)
      expect(assessment.canvas_description).to eq(instructions)
      expect(assessment.canvas_instructions).to eq(instructions)
      expect(assessment.canvas_points_possible).to eq(points_possible)
      expect(assessment.canvas_one_question_at_a_time?).to eq(oqaat)
      expect(assessment.canvas_allowed_attempts).to eq(allowed_attempts)
      expect(assessment.canvas_hide_results).to eq(hide_results)
      expect(assessment.canvas_quiz_type).to eq(quiz_type)
      expect(assessment.canvas_anonymous_submissions?).to eq(anon_submissions)
      expect(assessment.canvas_could_be_locked?).to eq(could_be_locked)
      expect(assessment.canvas_cant_go_back?).to eq(nobacktracking)
      expect(assessment.canvas_available?).to eq(available)
      expect(assessment.canvas_one_time_results?).to eq(one_time_results)
      expect(assessment.canvas_scoring_policy).to eq(scoring_policy)
      expect(assessment.canvas_cooling_period_seconds).to eq(cooling_period_seconds)
      expect(assessment.canvas_shuffle_questions?).to eq(shuffle_questions)
      expect(assessment.canvas_shuffle_answers?).to eq(shuffle_answers)
      expect(assessment.canvas_calculator_type).to eq(calculator_type)
      expect(assessment.canvas_lock_at).to eq(lock_at)
      expect(assessment.canvas_unlock_at).to eq(unlock_at)
      expect(assessment.canvas_due_at).to eq(due_at)
      expect(assessment.canvas_access_code).to eq(access_code)
      expect(assessment.canvas_ip_filter).to eq(ip_filter)
      expect(assessment.canvas_time_limit).to eq(time_limit)
      expect(assessment.canvas_show_correct_answers?).to eq(show_answers)
      expect(assessment.canvas_show_correct_answers_last_attempt?).to eq(show_correct_answers_last_attempt)
      expect(assessment.canvas_show_correct_answers_at).to eq(show_answers_at)
      expect(assessment.canvas_hide_correct_answers_at).to eq(hide_answers_at)
      expect(assessment.canvas_allow_clear_mc_selection?).to eq(allow_clear_mc_selection)
      expect(assessment.canvas_require_lockdown_browser?).to eq(rlb)
      expect(assessment.canvas_require_lockdown_browser_for_results?).to eq(rlb_results)
      expect(assessment.canvas_require_lockdown_browser_monitor?).to eq(rlb_monitor)
      expect(assessment.canvas_lockdown_browser_monitor_data).to eq(lb_monitor_data)
      expect(assessment.canvas_nq_ip_filters_enabled?).to eq(nq_ip_filters_enabled)
      expect(assessment.canvas_nq_ip_filters).to eq(nq_ip_filters)
      expect(assessment.canvas_result_view_restricted?).to eq(result_view_restricted)
      expect(assessment.canvas_display_items?).to eq(display_items)
      expect(assessment.canvas_display_item_response?).to eq(display_item_response)
      expect(assessment.canvas_display_item_feedback?).to eq(display_item_feedback)
      expect(assessment.canvas_display_points_awarded?).to eq(display_points_awarded)
      expect(assessment.canvas_display_points_possible?).to eq(display_points_possible)
      expect(assessment.canvas_display_item_correct_answer?).to eq(display_item_correct_answer)
      expect(assessment.canvas_display_item_response_correctness?).to eq(display_item_response_correctness)
      expect(assessment.canvas_display_item_response_qualifier).to eq(display_item_response_qualifier)
      expect(assessment.canvas_show_item_responses_at).to eq(show_item_responses_at)
      expect(assessment.canvas_hide_item_responses_at).to eq(hide_item_responses_at)
      expect(assessment.canvas_display_item_response_correctness_qualifier)
        .to eq(display_item_response_correctness_qualifier)
      expect(assessment.canvas_show_item_response_correctness_at).to eq(show_item_response_correctness_at)
      expect(assessment.canvas_hide_item_response_correctness_at).to eq(hide_item_response_correctness_at)
    end
  end

  describe 'in a QTI 1.2 container' do
    let(:qti_file) { 'test_qti_1.2_canvas' }
    let(:assessment_type) { Qti::V1::Models::Assessment }
    let(:title) { 'WIJsfijdi' }
    let(:instructions) { '<p>sdvsv</p>' }
    let(:points_possible) { 4.0 }
    let(:oqaat) { false }
    let(:allowed_attempts) { 1 }
    let(:hide_results) { nil }
    let(:quiz_type) { 'assignment' }
    let('anon_submissions') { false }
    let(:could_be_locked) { false }
    let(:nobacktracking) { false }
    let(:available) { true }
    let(:one_time_results) { false }
    let(:scoring_policy) { 'keep_highest' }
    let(:cooling_period_seconds) { nil }
    let(:shuffle_questions) { false }
    let(:shuffle_answers) { false }
    let(:calculator_type) { nil }
    let(:lock_at) { nil }
    let(:unlock_at) { nil }
    let(:due_at) { nil }
    let(:access_code) { nil }
    let(:ip_filter) { nil }
    let(:time_limit) { nil }
    let(:show_answers) { true }
    let(:show_correct_answers_last_attempt) { false }
    let(:show_answers_at) { nil }
    let(:hide_answers_at) { nil }
    let(:allow_clear_mc_selection) { false }
    let(:rlb) { false }
    let(:rlb_results) { false }
    let(:rlb_monitor) { false }
    let(:lb_monitor_data) { nil }
    let(:nq_ip_filters_enabled) { false }
    let(:nq_ip_filters) { [] }
    let(:result_view_restricted) { nil }
    let(:display_items) { false }
    let(:display_item_response) { false }
    let(:display_item_feedback) { false }
    let(:display_points_awarded) { false }
    let(:display_points_possible) { false }
    let(:display_item_correct_answer) { false }
    let(:display_item_response_correctness) { false }
    let(:display_item_response_qualifier) { nil }
    let(:display_item_response_correctness_qualifier) { nil }
    let(:show_item_responses_at) { nil }
    let(:hide_item_responses_at) { nil }
    let(:show_item_response_correctness_at) { nil }
    let(:hide_item_response_correctness_at) { nil }

    include_examples('loads canvas meta data')
  end

  describe 'in a QTI 1.2 container with extended fields' do
    let(:qti_file) { 'test_qti_1.2_canvas_extended_1' }
    let(:assessment_type) { Qti::V1::Models::Assessment }
    let(:title) { 'asd09sdfaxsdflj' }
    let(:instructions) { '<p>dlkjfaflkjla3rlajl3lafd</p>' }
    let(:points_possible) { 0.0 }
    let(:oqaat) { true }
    let(:allowed_attempts) { 52 }
    let(:hide_results) { nil }
    let(:quiz_type) { 'assignment' }
    let('anon_submissions') { false }
    let(:could_be_locked) { false }
    let(:nobacktracking) { true }
    let(:available) { false }
    let(:one_time_results) { false }
    let(:scoring_policy) { 'keep_average' }
    let(:shuffle_questions) { true }
    let(:cooling_period_seconds) { 86_400 }
    let(:shuffle_answers) { true }
    let(:calculator_type) { 'basic' }
    let(:lock_at) { '2020-07-10T04:59:59' }
    let(:unlock_at) { '2020-04-16T05:00:00' }
    let(:due_at) { '2020-05-23T04:59:59' }
    let(:access_code) { '98aAlfmxtw#!£$s' }
    let(:ip_filter) { '192.168.217.1/24' }
    let(:time_limit) { 187 }
    let(:show_answers) { true }
    let(:show_correct_answers_last_attempt) { false }
    let(:show_answers_at) { '2041-02-17 06:00:00 UTC' }
    let(:hide_answers_at) { '2042-12-26 06:00:00 UTC' }
    let(:allow_clear_mc_selection) { true }
    let(:rlb) { false }
    let(:rlb_results) { false }
    let(:rlb_monitor) { false }
    let(:lb_monitor_data) { nil }
    let(:nq_ip_filters_enabled) { true }
    let(:nq_ip_filters) do
      [
        ['255.255.0.0', '255.255.0.255'],
        ['255.255.0.255', '255.255.255.255']
      ]
    end
    let(:result_view_restricted) { true }
    let(:display_items) { true }
    let(:display_item_response) { true }
    let(:display_item_feedback) { true }
    let(:display_points_awarded) { true }
    let(:display_points_possible) { true }
    let(:display_item_correct_answer) { true }
    let(:display_item_response_correctness) { true }
    let(:display_item_response_qualifier) { 'once_per_attempt' }
    let(:display_item_response_correctness_qualifier) { 'after_last_attempt' }
    let(:show_item_responses_at) { '2024-07-18 06:00:00 UTC' }
    let(:hide_item_responses_at) { '2024-07-21 11:59:00 UTC' }
    let(:show_item_response_correctness_at) { '2024-07-19 06:00:00 UTC' }
    let(:hide_item_response_correctness_at) { '2024-07-22 11:59:00 UTC' }

    include_examples('loads canvas meta data')
  end

  describe 'in a QTI 1.2 container with extended fields and empty tags' do
    let(:qti_file) { 'test_qti_1.2_canvas_extended_2' }
    let(:assessment_type) { Qti::V1::Models::Assessment }
    let(:title) { '' }
    let(:instructions) { '' }
    let(:points_possible) { 0.0 }
    let(:oqaat) { false }
    let(:allowed_attempts) { 0 }
    let(:hide_results) { nil }
    let(:quiz_type) { nil }
    let('anon_submissions') { false }
    let(:could_be_locked) { false }
    let(:nobacktracking) { false }
    let(:available) { false }
    let(:one_time_results) { false }
    let(:scoring_policy) { nil }
    let(:cooling_period_seconds) { nil }
    let(:shuffle_questions) { false }
    let(:shuffle_answers) { false }
    let(:calculator_type) { nil }
    let(:lock_at) { nil }
    let(:unlock_at) { nil }
    let(:due_at) { nil }
    let(:access_code) { nil }
    let(:ip_filter) { nil }
    let(:time_limit) { nil }
    let(:show_answers) { false }
    let(:show_correct_answers_last_attempt) { false }
    let(:show_answers_at) { nil }
    let(:hide_answers_at) { nil }
    let(:allow_clear_mc_selection) { false }
    let(:rlb) { false }
    let(:rlb_results) { false }
    let(:rlb_monitor) { false }
    let(:lb_monitor_data) { nil }
    let(:nq_ip_filters_enabled) { false }
    let(:nq_ip_filters) { [] }
    let(:result_view_restricted) { nil }
    let(:display_items) { false }
    let(:display_item_response) { false }
    let(:display_item_feedback) { false }
    let(:display_points_awarded) { false }
    let(:display_points_possible) { false }
    let(:display_item_correct_answer) { false }
    let(:display_item_response_correctness) { false }
    let(:display_item_response_qualifier) { nil }
    let(:display_item_response_correctness_qualifier) { nil }
    let(:show_item_responses_at) { nil }
    let(:hide_item_responses_at) { nil }
    let(:show_item_response_correctness_at) { nil }
    let(:hide_item_response_correctness_at) { nil }

    include_examples('loads canvas meta data')
  end

  describe 'in a Common Cartridge container' do
    let(:qti_file) { 'test_imscc_canvas' }
    let(:assessment_type) { Qti::V1::Models::Assessment }
    let(:title) { 'Quiz #1' }
    let(:instructions) { '' }
    let(:points_possible) { 1.0 }
    let(:oqaat) { false }
    let(:allowed_attempts) { 1 }
    let(:hide_results) { nil }
    let(:quiz_type) { 'assignment' }
    let('anon_submissions') { false }
    let(:could_be_locked) { false }
    let(:nobacktracking) { false }
    let(:available) { true }
    let(:one_time_results) { false }
    let(:scoring_policy) { 'keep_highest' }
    let(:cooling_period_seconds) { nil }
    let(:shuffle_questions) { false }
    let(:shuffle_answers) { false }
    let(:calculator_type) { nil }
    let(:lock_at) { nil }
    let(:unlock_at) { nil }
    let(:due_at) { nil }
    let(:access_code) { nil }
    let(:ip_filter) { nil }
    let(:time_limit) { nil }
    let(:show_answers) { true }
    let(:show_correct_answers_last_attempt) { false }
    let(:show_answers_at) { nil }
    let(:hide_answers_at) { nil }
    let(:allow_clear_mc_selection) { false }
    let(:rlb) { false }
    let(:rlb_results) { false }
    let(:rlb_monitor) { false }
    let(:lb_monitor_data) { nil }
    let(:nq_ip_filters_enabled) { false }
    let(:nq_ip_filters) { [] }
    let(:result_view_restricted) { nil }
    let(:display_items) { false }
    let(:display_item_response) { false }
    let(:display_item_feedback) { false }
    let(:display_points_awarded) { false }
    let(:display_points_possible) { false }
    let(:display_item_correct_answer) { false }
    let(:display_item_response_correctness) { false }
    let(:display_item_response_qualifier) { nil }
    let(:display_item_response_correctness_qualifier) { nil }
    let(:show_item_responses_at) { nil }
    let(:hide_item_responses_at) { nil }
    let(:show_item_response_correctness_at) { nil }
    let(:hide_item_response_correctness_at) { nil }

    include_examples('loads canvas meta data')
  end
end
