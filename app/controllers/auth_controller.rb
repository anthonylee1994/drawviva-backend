class AuthController < ApplicationController
  skip_before_action :authorize_request, only: %i[login]

  def login
    firebase_auth_response = FirebaseAuthService.verify!(params[:token])

    user_data = firebase_auth_response.dig(:users, 0).slice(:display_name, :email, :photo_url)
    user = User.find_or_initialize_by(email: user_data[:email])
    user.assign_attributes(user_data.except(:email))
    user.save!

    response.headers['Authorization'] = "Bearer #{JwtService.encode(user_id: user.id)}"

    render json: user
  rescue FirebaseAuthService::InvalidToken => e
    render json: { error: e.message }, status: :unauthorized
  end

  def me
    render json: current_user, status: :ok
  end

  def update
    if current_user.update(user_params)
      head :no_content
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(push_notification_subscription_attributes: %i[auth endpoint p256dh])
  end
end
