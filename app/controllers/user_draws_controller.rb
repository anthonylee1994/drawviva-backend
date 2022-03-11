# frozen_string_literal: true

class UserDrawsController < ApplicationController
  before_action :set_user_draw, only: %i[update destroy]

  def create
    @user_draw = UserDraw.new(user_draw_params)

    authorize @user_draw

    if @user_draw.save
      render json: @user_draw, status: :created
    else
      render json: @user_draw.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user_draw.update(user_draw_params)
      head :no_content
    else
      render json: @user_draw.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user_draw

    @user_draw.destroy
    head :no_content
  end

  def set_user_draw
    @user_draw = UserDraw.find(params[:id])
  end

  private

  def user_draw_params
    params.require(:user_draw).permit(:role, :user_id, :draw_id)
  end
end
