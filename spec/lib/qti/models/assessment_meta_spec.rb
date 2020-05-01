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
      expect(assessment.canvas_shuffle_answers?).to eq(shuffle_answers)
      expect(assessment.canvas_lock_at).to eq(lock_at)
      expect(assessment.canvas_unlock_at).to eq(unlock_at)
      expect(assessment.canvas_due_at).to eq(due_at)
      expect(assessment.canvas_access_code).to eq(access_code)
      expect(assessment.canvas_ip_filter).to eq(ip_filter)
      expect(assessment.canvas_time_limit).to eq(time_limit)
      expect(assessment.canvas_show_correct_answers_at).to eq(show_answers_at)
      expect(assessment.canvas_hide_correct_answers_at).to eq(hide_answers_at)
      expect(assessment.canvas_require_lockdown_browser?).to eq(rlb)
      expect(assessment.canvas_require_lockdown_browser_for_results?).to eq(rlb_results)
      expect(assessment.canvas_require_lockdown_browser_monitor?).to eq(rlb_monitor)
      expect(assessment.canvas_lockdown_browser_monitor_data).to eq(lb_monitor_data)
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
    let(:shuffle_answers) { false }
    let(:lock_at) { nil }
    let(:unlock_at) { nil }
    let(:due_at) { nil }
    let(:access_code) { nil }
    let(:ip_filter) { nil }
    let(:time_limit) { nil }
    let(:show_answers_at) { nil }
    let(:hide_answers_at) { nil }
    let(:rlb) { false }
    let(:rlb_results) { false }
    let(:rlb_monitor) { false }
    let(:lb_monitor_data) { nil }

    include_examples('loads canvas meta data')
  end

  describe 'in a QTI 1.2 container with extended fields' do
    let(:qti_file) { 'test_qti_1.2_canvas_extended' }
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
    let(:shuffle_answers) { true }
    let(:lock_at) { '2020-07-10T04:59:59' }
    let(:unlock_at) { '2020-04-16T05:00:00' }
    let(:due_at) { '2020-05-23T04:59:59' }
    let(:access_code) { '98aAlfmxtw#!£$s' }
    let(:ip_filter) { '192.168.217.1/24' }
    let(:time_limit) { 187 }
    let(:show_answers_at) { '2041-02-17 06:00:00 UTC' }
    let(:hide_answers_at) { '2042-12-26 06:00:00 UTC' }
    let(:rlb) { false }
    let(:rlb_results) { false }
    let(:rlb_monitor) { false }
    let(:lb_monitor_data) { nil }

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
    let(:shuffle_answers) { false }
    let(:lock_at) { nil }
    let(:unlock_at) { nil }
    let(:due_at) { nil }
    let(:access_code) { nil }
    let(:ip_filter) { nil }
    let(:time_limit) { nil }
    let(:show_answers_at) { nil }
    let(:hide_answers_at) { nil }
    let(:rlb) { false }
    let(:rlb_results) { false }
    let(:rlb_monitor) { false }
    let(:lb_monitor_data) { nil }

    include_examples('loads canvas meta data')
  end
end
