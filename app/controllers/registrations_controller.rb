class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  rate_limit to: 10,
    within: 3.minutes,
    only: :create,
    with: -> { redirect_to new_registration_url, alert: "Try again later." }

  def new
    if authenticated?
      redirect_to root_url, notice: "Jste již přihlášen."
      return
    end

    @user = User.new
  end

  def create
    @user = User.new(safe_params)

    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_url, notice: "Úspěšně jste se zaregistrovali."
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def safe_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end
