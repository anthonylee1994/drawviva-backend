class UserDrawsController < ApplicationController
  def create
    @draw_user = UserDraw.new(user_draw_params)

    authorize @draw_user

    if @draw_user.save
      render json: @draw_user, status: :created
    else
      render json: @draw_user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @draw_user = UserDraw.find(params[:id])
    authorize @draw_user

    @draw_user.destroy
    head :no_content
  end

  private

  def user_draw_params
    params.require(:user_draw).permit(:role, :user_id, :draw_id)
  end
end
