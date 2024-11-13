class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    render json: request.env['omniauth.auth']
  end
end
