class PhotosController < ApplicationController
  allow_unauthenticated_access only: [ :index ]

  def index
    # @photos = Current.user.photos
    @photos = Photo.all
  end

  def new
  end

  def create
  end
end
