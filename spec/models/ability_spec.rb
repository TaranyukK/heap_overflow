require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, :with_file, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:comment) { create(:comment, commentable: question, user: user) }
    let(:other_question) { create(:question, :with_file, user: other_user) }
    let(:other_answer) { create(:answer, question: other_question, user: other_user) }
    let(:other_comment) { create(:comment, commentable: other_question, user: other_user) }
    let(:link) { create(:link, linkable: question) }
    let(:other_link) { create(:link, linkable: other_question) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :update, comment }
    it { should_not be_able_to :update, other_comment }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }

    it { should be_able_to :destroy, comment }
    it { should_not be_able_to :destroy, other_comment }

    it { should be_able_to :vote_up, other_question }
    it { should_not be_able_to :vote_up, question }

    it { should be_able_to :vote_down, other_question }
    it { should_not be_able_to :vote_down, question }

    it { should be_able_to :vote_up, other_answer }
    it { should_not be_able_to :vote_up, answer }

    it { should be_able_to :vote_down, other_answer }
    it { should_not be_able_to :vote_down, answer }

    it { should be_able_to :mark_as_best, create(:answer, question: question) }
    it { should_not be_able_to :mark_as_best, create(:answer, question: other_question) }

    it { should be_able_to :destroy, link }
    it { should_not be_able_to :destroy, other_link }

    it { should be_able_to :destroy, question.files.first }
    it { should_not be_able_to :destroy, other_question.files.first }
  end

  describe 'for admin' do
    let(:user) { create(:user, :admin) }

    it { should be_able_to :manage, :all }
  end
end
