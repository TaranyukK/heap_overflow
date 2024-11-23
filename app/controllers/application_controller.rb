class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_path, alert: e.message
  end

  check_authorization unless: :devise_controller?
end
