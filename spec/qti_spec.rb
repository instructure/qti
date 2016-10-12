# require 'spec_helper'

# describe Qti::Importer do

#   let(:fixtures_path) { File.join('spec', 'fixtures') }
#   let(:importer) { Qti::Importer.new(file_path) }
#   subject { importer.import }

#   shared_examples_for 'qti import' do
#     it 'loads an xml file' do
#       expect { Qti::Importer.import!(file_path) }.to_not raise_error
#     end
#   end

#   shared_examples_for 'new quiz building' do
#     it 'makes one quiz' do
#       expect { subject }.to change { Quiz.count }.by 1
#     end

#     it 'has the correct number of quizzes_items and items' do
#       expect { subject }.to change { QuizzesItem.count }.by(expected_item_count)
#         .and change { Item.count }.by(expected_item_count)
#     end
#   end

#   shared_examples_for 'updating an existing quiz' do
#     let(:existing_quiz) { Quiz.create title: 'existing title' }
#     subject { importer.import(quiz: existing_quiz) }

#     it 'updates a quiz' do
#       # preload this
#       existing_quiz
#       expect { subject }.to change { Quiz.count }.by 0
#     end

#     it 'updates the quiz title' do
#       expect(subject.title).to eq quiz_title
#     end

#     it 'builds the correct number of quizzes_items and items' do
#       expect { subject }.to change { QuizzesItem.count }.by(expected_item_count)
#         .and change { Item.count }.by(expected_item_count)
#     end

#     it 'associates quizzes_items with the existing quiz' do
#       expect(subject.quizzes_items.count).to eq expected_item_count
#     end
#   end

#   shared_examples_for 'importing a quiz' do
#     let(:qti_import) { create :qti_import }
#     let(:importer) { Qti::Importer.new(file_path, qti_import) }
#     subject { importer.import(quiz: qti_import.quiz) }

#     it 'updates a quiz' do
#       # Preload quiz
#       qti_import
#       expect { subject }.to change { Quiz.count }.by 0
#     end

#     it 'updates the quiz title' do
#       expect(subject.title).to eq quiz_title
#     end

#     it 'updates qti_import' do
#       subject
#       expect(qti_import.progress).to eq 1.0
#     end

#     it 'builds the correct number of quizzes_items and items' do
#       expect { subject }.to change { QuizzesItem.count }.by(expected_item_count)
#         .and change { Item.count }.by(expected_item_count)
#     end

#     it 'associates quizzes_items with the existing quiz' do
#       expect(subject.quizzes_items.count).to eq expected_item_count
#     end
#   end

#   context 'QTI 1.2' do
#     let(:file_path) { File.join(fixtures_path, 'test_qti_1.2') }
#     let(:quiz_title) { '1.2 Import Quiz' }
#     let(:expected_item_count) { 3 }

#     include_examples 'qti import'

#     context 'builds a new quiz' do
#       include_examples 'new quiz building'
#     end

#     context 'updates an existing quiz' do
#       include_examples 'updating an existing quiz'
#     end

#     context 'from a qti import' do
#       include_examples 'importing a quiz'
#     end
#   end

#   context 'QTI 2.1' do
#     let(:file_path) { File.join(fixtures_path, 'test_qti_2.1') }
#     let(:expected_item_count) { 3 }
#     let(:quiz_title) { 'Simple Feedback Test' }

#     include_examples 'qti import'

#     context 'builds a new quiz' do
#       include_examples 'new quiz building'

#       it 'has the 1 failed item' do
#         subject
#         expect(importer.errored_files.count).to eq 1
#       end
#     end

#     context 'updates an existing quiz' do
#       include_examples 'updating an existing quiz'

#       it 'has the 1 failed items' do
#         subject
#         expect(importer.errored_files.count).to eq 1
#       end
#     end

#     context 'from a qti import' do
#       include_examples 'importing a quiz'

#       it 'has the 1 failed items' do
#         subject
#         expect(importer.errored_files.count).to eq 1
#       end
#     end
#   end
# end
