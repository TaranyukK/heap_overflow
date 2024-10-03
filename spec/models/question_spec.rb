require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many :answers }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#best_answer' do
    let(:question) { create(:question) }

    context 'with best answer' do
      let!(:first_answer) { create(:answer, question: question) }
      let!(:second_answer) { create(:answer, :best, question: question) }

      it { expect(question.reload.best_answer).to eq(second_answer) }
    end

    context 'without best answer' do
      let!(:first_answer) { create(:answer, question: question) }
      let!(:second_answer) { create(:answer, question: question) }

      it { expect(question.reload.best_answer).to eq(nil) }
    end

    context 'without answers' do
      it { expect(question.reload.best_answer).to eq(nil) }
    end
  end
end
