require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should belong_to :question }

  it { should validate_presence_of :body }

  describe 'scopes' do
    let!(:answers) { create_list(:answer, 3) }

    describe '#sort_by_best' do
      context 'without best answer' do
        it { expect(described_class.sort_by_best).to match_array(answers) }
      end

      context 'with best answer' do
        let!(:best_answer) { create(:answer, :best) }

        it { expect(described_class.sort_by_best).to match_array([best_answer] + answers) }
      end
    end

    describe '#best' do
      context 'without best answer' do
        it { expect(described_class.best).to be_empty }
      end

      context 'with best answer' do
        let!(:best_answer) { create(:answer, :best) }

        it { expect(described_class.best).to contain_exactly(best_answer) }
      end
    end
  end

  describe '#mark_as_best' do
    let(:question) { create(:question) }
    let!(:answer1) { create(:answer, question:) }
    let!(:answer2) { create(:answer, question:) }

    context 'when there is no best answer' do
      it 'marks the answer as best' do
        answer1.mark_as_best
        expect(answer1.reload.best).to be true
      end
    end

    context 'when there is a best answer' do
      let!(:best_answer) { create(:answer, :best, question:) }

      it 'marks the new answer as best and unmarks the previous best answer' do
        answer2.mark_as_best
        expect(answer2.reload.best).to be true
        expect(best_answer.reload.best).to be false
      end
    end
  end
end
