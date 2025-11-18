class OauthController < ApplicationController
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
    # コールバック後の処理は後ほど実装、ひとまず写真一覧にリダイレクト
    redirect_to photos_path
  end
end
