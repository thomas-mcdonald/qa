class Admin::UsersController < ApplicationController
  before_action :set_content_warning
  before_action :require_admin

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(updatable_attributes)
      redirect_to user
    else
      render action: :edit
    end
  end

  private

  def set_content_warning
    @admin_page_warning = true
  end

  def updatable_attributes
    params.require(:user).permit(:admin, :moderator)
  end
end
