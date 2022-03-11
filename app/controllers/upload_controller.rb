class UploadController < ApplicationController
  def create
    url = UploadService.upload_image(params[:image])
    render json: { url: }
  end
end
