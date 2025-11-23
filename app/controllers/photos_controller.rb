class PhotosController < ApplicationController
    require "net/http"
    require "uri"
    require "json"
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

  def tweet
    photo = Current.user.photos.find(params[:id])
    image_url = url_for(photo.image)

    uri = URI("#{Rails.application.credentials.twitter[:url]}/api/tweets")

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{session[:twitter_access_token]}"
    request.body = {
      text: photo.title,
      url: image_url
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    if response.code == "201"
      redirect_to photos_path, notice: "ツイートしました"
    else
      redirect_to photos_path, alert: "ツイートに失敗しました"
    end
  end

  private
  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
