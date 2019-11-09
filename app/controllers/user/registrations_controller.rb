class User::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_paramaters

  protected

  # Include first_name and last_name in Devise's permitted parameters for sign up and edit
  def configure_permitted_paramaters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end
end
