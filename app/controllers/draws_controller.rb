# frozen_string_literal: true

class DrawsController < ApplicationController
  before_action :set_draw, only: %i[update destroy]

  def index
    @draws = current_user.draws.includes(*draw_attributes).order(created_at: :desc)

    render json: @draws, status: :ok, include: draw_attributes
  end

  def create
    @draw = current_user.draws.new(draw_params)

    if @draw.save
      render json: @draw, status: :created, include: draw_attributes
    else
      render json: @draw.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @draw

    if @draw.update(draw_params)
      head :no_content
    else
      render json: @draw.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @draw

    if @draw.destroy
      head :no_content
    else
      render json: @draw.errors, status: :unprocessable_entity
    end
  end

  def set_draw
    @draw = Draw.find(params[:id])
  end

  def draw_attributes
    [:draw_items, :user_draws, { user_draws: :user }]
  end

  def draw_params
    params.require(:draw).permit(:name, :image_url)
  end
end
