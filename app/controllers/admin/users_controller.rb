class Admin::UsersController < ApplicationController
  layout 'table', only: [:index]
  before_filter :seed_admin
  before_action :current_user_is_admin
  
  # GET /admin/users
  def index
    @users = User.all
    @users_without_group_not_suspended = User.where("(users.group_id IS NULL) AND (users.locked_at IS NULL)")
    @users_with_group_not_suspended = User.where("(users.group_id IS NOT NULL) AND (users.locked_at IS NULL)")
    @users_suspended = User.where("users.locked_at IS NOT NULL")
  end
  
  # GET /admin/users/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  # PATCH/PUT /admin/users/1
  # PATCH/PUT /admin/users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_users_path, notice: 'User was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:group_id, :admin, :locked_at, :is_producer, :about_text, :about_url, :buyer_tag)
  end
  
  def seed_admin
    User.order(:id).first.update(admin: true) if User.where(admin: true).empty?
  end
end