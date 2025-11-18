class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    email_address = params[:email_address]
    password = params[:password]
    errors = []

    if email_address.blank?
      errors << "メールアドレスを入力してください。"
    end

    if password.blank?
      errors << "パスワードを入力してください。"
    end

    if errors.any?
      flash.now[:alert] = errors
      render :new, status: :unprocessable_entity
      return
    end

    if user = User.authenticate_by(email_address: email_address, password: password)
      start_new_session_for user
      redirect_to after_authentication_url
    else
      flash.now[:alert] = [ "メールアドレスまたはパスワードが正しくありません。" ]
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
