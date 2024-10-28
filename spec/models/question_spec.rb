require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'linkable'

  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#best_answer' do
    let(:question) { create(:question) }

    context 'with best answer' do
      let(:first_answer) { create(:answer, question: question) }
      let!(:second_answer) { create(:answer, :best, question: question) }

      it { expect(question.reload.best_answer).to eq(second_answer) }
    end

    context 'without best answer' do
      let(:first_answer) { create(:answer, question: question) }
      let(:second_answer) { create(:answer, question: question) }

      it { expect(question.reload.best_answer).to be_nil }
    end

    context 'without answers' do
      it { expect(question.reload.best_answer).to be_nil }
    end
  end

  describe '#give_award!' do
    let(:user) { create(:user) }

    context 'gives award' do
      let(:question) { create(:question, :with_award) }
      let(:award) { question.award }

      before { question.give_award!(user) }

      it { expect(award).to eq(user.awards.first) }
    end

    context 'if no award' do
      let(:question) { create(:question) }

      before { question.give_award!(user) }

      it { expect(question.award).to be_nil }
    end
  end
end
