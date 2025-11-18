class PhotosController < ApplicationController
  def index
    @photos = Current.user.photos.order(created_at: :desc)
  end

  def new
    @photo = Current.user.photos.build
  end

  def create
    @photo = Current.user.photos.build(photo_params)
    if @photo.save
      redirect_to photos_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
