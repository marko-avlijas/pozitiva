class ProfilesController < ApplicationController
  
  before_action :set_user, only: [:show, :update, :about_attach, :delete_about_attach, :message]
  before_action :current_user_is_owner, only: [:update, :delete_about_attach]
  
  # GET /profiles
  def index
  end

  # GET /profiles/1
  def show
    @show_delete = (@user == current_user)
    @contact_form_url = message_profile_path(@user)
  end
  
  def my_profile
    @user = User.find(current_user.id)
  end
  
  def message
    message = Message.new(params[:message])
    
    if message.valid?
      NotificationsMailer.message_to_user(current_user, @user, message).deliver
      redirect_to(profile_path, notice: "Poruka je uspješno poslana.")
    else
      flash.now.alert = "Potrebno je popuniti sva polja."
      render :show
    end
  end
  
  # # GET /profiles/1/edit
  # def edit
  # end
  
  # PATCH/PUT /profiles/1
  def update
    @user.download_avatar(params[:avatar_url])
    if @user.handle_about_attach(profile_params[:about_attach]) and @user.update(profile_params.except(:about_attach))
      redirect_to profile_path(@user), notice: 'Promjene na korisničkom profilu su uspješno spremljene.'
    else
      render action: 'my_profile'
    end
  end
  
  def about_attach
    send_data(@user.about_attach, type: @user.about_attach_mime_type, disposition: "inline") if @user.try(:about_attach)
  end
  
  def delete_about_attach
    if @user.update(about_attach: nil, about_attach_mime_type: nil, about_attach_file_size: nil)
      redirect_to my_profile_path, notice: 'Promjene na korisničkom profilu su uspješno spremljene.'
    else
      render action: 'edit'
    end  
  end
  
  private
   
  def current_user_is_owner
    raise "[ProfilesController#current_user_is_owner]" if current_user != @user && !current_user.admin?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
  
  def profile_params
    params.require(:user).permit(:about_text, :about_url, :phone, :about_attach, :company_name, :company_address, :company_oib, :neighborhood) # can't change email, name
  end  

end
