class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!
  
  def resource_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :login)
  end
  private :resource_params
end