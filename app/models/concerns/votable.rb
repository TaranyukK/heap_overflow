module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_up(user)
    vote(user, 1)
  end

  def vote_down(user)
    vote(user, -1)
  end

  def rating
    votes.sum(:value)
  end

  private

  def vote(user, value)
    return if user.author?(self)

    user_vote = votes.find_or_initialize_by(user:)

    if user_vote.new_record?
      user_vote.value = value
      user_vote.save
    else
      user_vote.value == value ? user_vote.destroy : user_vote.update(value:)
    end
  end
end
