class UsersController < ApplicationController
  def index
    @users = User.ransack(email_start: params[:q]).result.order(email: :asc).first(10)

    render json: @users, status: :ok
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

  def user_params
    params.require(:user).permit(push_notification_subscription_attributes: %i[auth endpoint p256dh])
  end
end
