class OauthController < ApplicationController
  require "net/http"
  require "uri"
  require "json"

  def authorize
    authorize_url = "#{Rails.application.credentials.twitter[:url]}/oauth/authorize"

    params = {
      response_type: "code",
      client_id: Rails.application.credentials.twitter[:client_id],
      redirect_uri: "http://localhost:3000/oauth/callback",
      scope: "write_tweet"
    }

    redirect_to "#{authorize_url}?#{params.to_query}", allow_other_host: true
  end

  def callback
    code = params[:code]

    uri = URI("#{Rails.application.credentials.twitter[:url]}/oauth/token")
    token_params = {
      grant_type: "authorization_code",
      code: code,
      redirect_uri: "http://localhost:3000/oauth/callback",
      client_id: Rails.application.credentials.twitter[:client_id],
      client_secret: Rails.application.credentials.twitter[:client_secret]
    }
    response = Net::HTTP.post_form(uri, token_params)
    token_response = JSON.parse(response.body)

    session[:twitter_access_token] = token_response["access_token"]
    redirect_to photos_path
  end
end
