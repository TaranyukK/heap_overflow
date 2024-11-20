class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)

    return authorization.user if authorization

    email = auth.info.email
    user = User.find_by(email:)

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email:, password:, password_confirmation: password)
    end
    create_authorization(user, auth)

    user
  end

  private

  def create_authorization(user, auth)
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
