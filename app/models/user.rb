class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def author?(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth); end
end
