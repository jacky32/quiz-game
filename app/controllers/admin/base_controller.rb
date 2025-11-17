class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    unless Current.user&.admin?
      redirect_to root_path, alert: "Nemáte oprávnění k přístupu do administrátorské sekce."
    end
  end
end
