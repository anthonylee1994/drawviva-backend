class DrawsController < ApplicationController
  def index
    @draws = current_user.draws

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
    @draw = Draw.find(params[:id])
    authorize @draw

    if @draw.update(draw_params)
      head :no_content
    else
      render json: @draw.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @draw = current_user.admin_draws.find(params[:id])
    authorize @draw
    @draw.destroy

    head :no_content
  end

  def draw_params
    params.require(:draw).permit(:name, :image_url)
  end
end
