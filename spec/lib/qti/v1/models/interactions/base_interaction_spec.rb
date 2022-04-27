describe Qti::V1::Models::Interactions::BaseInteraction do
  let(:doc) do
    <<~XML
      <?xml version="1.0" encoding="ISO-8859-1"?>
      <questestinterop xmlns="http://www.imsglobal.org/xsd/ims_qtiasiv1p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd">
        <response_lid ident="QUE_1008_RL" rtiming="No">
        </response_lid>
      </questestinterop>
    XML
  end

  let(:node) { Nokogiri.XML(doc, &:noblanks) }
  let(:assessment) { double(path: 'dummy/blah', package_root: 'dummy') }

  it 'returns "Single" rcardinality by default' do
    interaction = described_class.new(node, assessment)
    expect(interaction.rcardinality).to eq 'Single'
  end

  let(:fixtures_path) { File.join('spec', 'fixtures', 'items_1.2') }
  let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
  let(:assessment_item_refs) { test_object.assessment_items }
  let(:loaded_class) { described_class.new(assessment_item_refs.first, test_object) }

  shared_examples_for 'item_level_feedback' do
    it 'returns the correct item-level feedback' do
      expect(loaded_class.canvas_item_feedback[:neutral]).to eq(general_fb)
      expect(loaded_class.canvas_item_feedback[:correct]).to eq(correct_fb)
      expect(loaded_class.canvas_item_feedback[:incorrect]).to eq(incorrect_fb)
    end
  end

  shared_examples_for 'answer_feedback' do
    it 'returns the correct answer feedback' do
      expect(loaded_class.answer_feedback).to eq(answer_fb)
    end
  end

  context 'canvas_multiple_dropdown.xml' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_dropdown.xml') }
    let(:general_fb) do
      "<p>Roses come in many colors, violets probably do too.</p>\n<p>Never the less, " \
      'the correct answers were <strong>red</strong> and <strong>blue</strong>.</p>'
    end
    let(:correct_fb) { '<p>Completing the poem, is left to you.</p>' }
    let(:incorrect_fb) { '<p>Those aren\'t colors, you meant <strong>red</strong> and <strong>blue</strong>.</p>' }

    let(:answer_fb) do
      [
        { response_id: 'response_color1', response_value: '6548',
          texttype: 'text/html', feedback: '<p>Yes! <strong>Red</strong>.</p>' },
        { response_id: 'response_color1', response_value: '5550',
          texttype: 'text/html', feedback: "<p>I'm pretty sure you meant <strong>red.</strong></p>" },
        { response_id: 'response_color2', response_value: '6951',
          texttype: 'text/html', feedback: '<p>Yes, <strong>blue</strong>!</p>' },
        { response_id: 'response_color2', response_value: '4500',
          texttype: 'text/html', feedback: '<p>Did you also chose plaid? You wanted to <strong>blue</strong>.</p>' }
      ]
    end

    include_examples('item_level_feedback')
    include_examples('answer_feedback')
  end

  context 'canvas_multiple_fib.xml' do
    let(:file_path) { File.join(fixtures_path, 'canvas_multiple_fib.xml') }
    let(:general_fb) { nil }
    let(:correct_fb) { nil }
    let(:incorrect_fb) { nil }
    let(:answer_fb) { nil }

    include_examples('item_level_feedback')
    include_examples('answer_feedback')
  end

  context 'mc_feedback.xml' do
    let(:file_path) { File.join(fixtures_path, 'mc_feedback.xml') }
    let(:general_fb) { '<p>General Feedback</p>' }
    let(:correct_fb) { '<p>General Correct Feedback</p>' }
    let(:incorrect_fb) { '<p>General Incorrect Feedback</p>' }
    let(:answer_fb) do
      [
        { response_id: 'response1', response_value: '5706',
          texttype: 'text/html', feedback: '<p>Answer A Feedback</p>' },
        { response_id: 'response1', response_value: '2408',
          texttype: 'text/html', feedback: '<p>Answer B Feedback</p>' },
        { response_id: 'response1', response_value: '621',
          texttype: 'text/html', feedback: '<p>Answer C Feedback</p>' },
        { response_id: 'response1', response_value: '7011',
          texttype: 'text/html', feedback: '<p>Answer D Feedback</p>' }
      ]
    end

    include_examples('item_level_feedback')
    include_examples('answer_feedback')
  end
end
