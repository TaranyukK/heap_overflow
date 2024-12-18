class User < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search,
                  against: :email,
                  using:   {
                    tsearch: { prefix: true }
                  }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github facebook]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author?(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def subscribed?(resource)
    subscriptions.exists?(question_id: resource.id)
  end
end
