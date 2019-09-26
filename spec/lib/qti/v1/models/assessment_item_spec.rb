describe Qti::V1::Models::AssessmentItem do
  context 'multiple_fib' do
    let(:file_path) { File.join('spec', 'fixtures', 'items_1.2', 'single_fib.xml') }
    let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
    let(:assessment_item_refs) { test_object.assessment_items }
    let(:loaded_class) { described_class.new(assessment_item_refs) }

    it 'has sanitized item_body' do
      expect(loaded_class.item_body).to include '<div'
    end
  end

  context 'quiz.xml' do
    let(:file_path) { File.join('spec', 'fixtures', 'items_1.2', 'true_false.xml') }
    let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
    let(:assessment_item_refs) { test_object.assessment_items }
    let(:loaded_class) { described_class.new(assessment_item_refs) }

    it 'loads an AssessmentItem ref' do
      expect do
        described_class.new(assessment_item_refs)
      end.to_not raise_error
    end

    it 'has the title' do
      expect(loaded_class.title).to eq 'Grading - specific - 3 pt score'
    end

    it 'has sanitized item_body' do
      expect(loaded_class.item_body).to include '<img'
      expect(loaded_class.item_body).to include 'If I get a 3, I must have done something wrong.'
    end

    describe '#points_possible' do
      it 'grabs the points possible' do
        expect(loaded_class.points_possible).to eq 1
      end

      it 'returns 0 by default' do
        node = Nokogiri.XML(<<~XML, &:noblanks)
          <?xml version="1.0" encoding="ISO-8859-1"?>
          <questestinterop xmlns="http://www.imsglobal.org/xsd/ims_qtiasiv1p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd">
            <outcomes>
              <decvar vartype="Decimal" varname="que_score"/>
            </outcomes>
          </questestinterop>
        XML
        assessment_item = described_class.new(node)
        expect(assessment_item.points_possible).to eq 1
      end
    end

    describe '#scoring_data_structs' do
      it 'grabs the rcardinality and scoring data value' do
        struct = loaded_class.send(:scoring_data_structs)
        expect(struct.first.values).to eq 'QUE_1006_A2'
        expect(struct.first.rcardinality).to eq 'Single'
      end
    end

    it 'has the identifier used to identify it in manifest/test files' do
      expect(loaded_class.identifier).to eq 'QUE_1003'
    end

    it 'loads the interaction_model without erroring' do
      expect { loaded_class.interaction_model }.not_to raise_error
    end

    it 'loads the correct interaction model' do
      expect(loaded_class.interaction_model).to be_an_instance_of(
        Qti::V1::Models::Interactions::ChoiceInteraction
      )
    end
  end

  context 'multiple_answer_canvas.xml' do
    let(:file_path) { File.join('spec', 'fixtures', 'items_1.2', 'multiple_answer_canvas.xml') }
    let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
    let(:assessment_item_refs) { test_object.assessment_items }
    let(:loaded_class) { described_class.new(assessment_item_refs) }

    describe '#scoring_data_structs' do
      it 'collects all the correct answers' do
        struct = loaded_class.scoring_data_structs
        expect(struct.size).to eq 3
        expect(struct.map(&:values)).to eq %w[4155 6991 1939]
      end
    end

    it 'sets the points possible from qtimetadata' do
      expect(loaded_class.points_possible).to eq '1.0'
    end

    it 'returns the prompt inner content without &lt or &gt' do
      expect(loaded_class.item_body).not_to include('&lt;', '&gt;')
      expect(loaded_class.item_body).to include '<div><p>Multiple Answer pick A C and D</p></div>'
    end
  end

  context 'formula.xml' do
    let(:file_path) { File.join('spec', 'fixtures', 'items_1.2', 'formula.xml') }
    let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
    let(:assessment_item_refs) { test_object.assessment_items }
    let(:loaded_class) { described_class.new(assessment_item_refs) }

    describe '#scoring_data_structs' do
      it 'collects all the correct answers' do
        struct = loaded_class.scoring_data_structs
        expect(struct.size).to eq 5
      end
    end
  end

  context 'inner_content' do
    describe 'unescaped html' do
      let(:file_path) { File.join('spec', 'fixtures', 'items_1.2', 'matching.xml') }
      let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
      let(:assessment_item_refs) { test_object.assessment_items }
      let(:loaded_class) { described_class.new(assessment_item_refs) }

      it 'returns the prompt inner content without &lt or &gt' do
        expect(loaded_class.item_body).not_to include('&lt;', '&gt;')
        expect(loaded_class.item_body).to include '<div><strong>'
      end
    end

    describe 'escaped html' do
      let(:file_path) { File.join('spec', 'fixtures', 'items_1.2', 'essay.xml') }
      let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
      let(:assessment_item_refs) { test_object.assessment_items }
      let(:loaded_class) { described_class.new(assessment_item_refs) }

      it 'returns the prompt inner content without &lt or &gt' do
        expect(loaded_class.item_body).not_to include('&lt;', '&gt;')
        expect(loaded_class.item_body).to include '<div><p>'
      end
    end

    describe 'CDATA html' do
      let(:file_path) { File.join('spec', 'fixtures', 'items_1.2', 'choice.xml') }
      let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
      let(:assessment_item_refs) { test_object.assessment_items }
      let(:loaded_class) { described_class.new(assessment_item_refs) }

      it 'returns the prompt inner content without &lt or &gt' do
        expect(loaded_class.item_body).not_to include('&lt;', '&gt;')
        expect(loaded_class.item_body).to include '<img'
      end
    end

    context 'without title' do
      let(:file_path) { File.join('spec', 'fixtures', 'items_1.2', 'item_no_title.xml') }
      let(:test_object) { Qti::V1::Models::Assessment.from_path!(file_path) }
      let(:assessment_item_refs) { test_object.assessment_items }
      let(:loaded_class) { described_class.new(assessment_item_refs) }

      it 'returns nil title without exceptions' do
        expect(loaded_class.title).to be_nil
      end
    end
  end
end
