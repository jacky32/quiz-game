class UsersController < ApplicationController
  def edit
    @user = Current.user
  end

  def update
    @user = Current.user

    if @user.update(user_params)
      redirect_to dashboard_path, notice: "Úspěšně jste aktualizovali svůj profil."
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [ :name, :email_address, :password, :password_confirmation, :avatar ])
  end
end
