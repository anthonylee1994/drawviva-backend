class DrawsController < ApplicationController
  before_action :set_draw, only: %i[update destroy]

  def index
    @draws = current_user.draws.includes(:user_draws, :draw_items)

    render json: @draws, status: :ok
  end

  def create
    @draw = current_user.draws.new(draw_params)

    if @draw.save
      render json: @draw, status: :created
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

  def draw_params
    params.require(:draw).permit(:name, :image_url)
  end
end
