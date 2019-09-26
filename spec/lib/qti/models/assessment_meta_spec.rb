context 'Canvas Assessment Meta Data' do
  let(:fixtures_path) { File.join('spec', 'fixtures') }
  let(:file_path) { File.join(fixtures_path, qti_file) }
  let(:assessment) { Qti::Importer.new(file_path).test_object }

  shared_examples 'loads canvas meta data' do
    it 'creates a vaild assessment' do
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
    let(:hide_results) { '' }
    let(:quiz_type) { 'assignment' }
    let('anon_submissions') { false }
    let(:could_be_locked) { false }
    let(:nobacktracking) { false }
    let(:available) { true }
    let(:one_time_results) { false }
    let(:scoring_policy) { 'keep_highest' }
    let(:shuffle_answers) { false }

    include_examples('loads canvas meta data')
  end
end
