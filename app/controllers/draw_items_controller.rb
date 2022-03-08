# frozen_string_literal: true

class DrawItemsController < ApplicationController
  before_action :set_draw, only: %i[draw create]
  before_action :set_draw_item, only: %i[update destroy]

  def draw
    authorize @draw, :draw?

    @draw_item = @draw.random_pick!(current_user)

    render json: @draw_item, status: :ok
  end

  def create
    @draw_item = @draw.draw_items.new(draw_item_params)

    authorize @draw_item

    if @draw_item.save
      render json: @draw_item, status: :created
    else
      render json: @draw_item.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @draw_item

    if @draw_item.update(draw_item_params)
      render json: @draw_item
    else
      render json: @draw_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @draw_item

    if @draw_item.destroy
      head :no_content
    else
      render json: @draw_item.errors, status: :unprocessable_entity
    end
  end

  def set_draw
    @draw = Draw.find(params[:draw_id])
  end

  def set_draw_item
    @draw_item = DrawItem.find(params[:id])
  end

  def draw_item_params
    params.require(:draw_item).permit(:image_url, :name)
  end
end
