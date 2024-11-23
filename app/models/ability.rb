# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    guest_abilities
    return unless user.present?
    user_abilities
    return unless user.admin?
    admin_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], { user_id: user.id }

    can [:create, :update, :destroy], Link do |link|
      link.linkable.user_id == user.id
    end

    can [:vote_up, :vote_down], [Question, Answer] do |votable|
      votable.user_id != user.id
    end

    can :mark_as_best, Answer do |answer|
      answer.question.user_id == user.id
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
