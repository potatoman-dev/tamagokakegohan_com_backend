class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def sign_up_params
    params.permit(:email, :password, :password_confirmation, :name)
  end
end
