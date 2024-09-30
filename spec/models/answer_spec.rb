require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }

  it { should validate_presence_of :body }

  describe 'scopes' do
    let!(:answers) { create_list(:answer, 3) }

    describe '#sort_by_best' do
      context 'without best answer' do
        it { expect(Answer.sort_by_best).to match_array(answers) }
      end

      context 'with best answer' do
        let!(:best_answer) { create(:answer, :best) }

        it { expect(Answer.sort_by_best).to match_array([best_answer] + answers) }
      end
    end

    describe '#best' do
      context 'without best answer' do
        it { expect(Answer.best).to match_array([]) }
      end

      context 'with best answer' do
        let!(:best_answer) { create(:answer, :best) }

        it { expect(Answer.best).to match_array([best_answer]) }
      end
    end
  end
end
