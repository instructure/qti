# require 'spec_helper'

# describe Qti::V2::Models::AssessmentItem do
#   context 'object element' do
#     let(:path) { File.join('spec', 'fixtures', 'no_assessment_XML', '59ee7c9d-e6cc-4d0c-b545-258e20b1a244.xml') }
#     let(:loaded_class) { described_class.from_path!(path) }

#     it 'loads an AssessmentItem XML file containing object elements' do
#       expect { loaded_class.item_body }.not_to raise_error
#     end

#     it 'imports html objects' do
#       body = loaded_class.item_body
#       expect(body).to include 'Listen to the musical example'
#     end

#     it 'sanitizes imported html' do
#       body = loaded_class.interaction_model.answers.first.item_body
#       expect(body).to include 'test to ensure this stuff gets sanitized'
#       expect(body).not_to include '<script>'
#     end

#     it 'converts image objects' do
#       body = loaded_class.interaction_model.answers.last.item_body
#       expect(body).to include '<img src="some_image.jpg">'
#     end
#   end
# end
