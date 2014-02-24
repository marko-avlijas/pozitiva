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
      redirect_to(profile_path, notice: "Message was successfully sent.")
    else
      flash.now.alert = "Please fill all fields."
      render :show
    end
  end
  
  # # GET /profiles/1/edit
  # def edit
  # end
  
  # PATCH/PUT /profiles/1
  def update
    respond_to do |format|
      if @user.update(profile_params) && handle_upload
        format.html { redirect_to my_profile_path, notice: 'Profile was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: 'my_profile' }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def about_attach
    send_data(@user.about_attach, type: @user.about_attach_mime_type, disposition: "inline") if @user.try(:about_attach)
  end
  
  def delete_about_attach
    @user.about_attach = @user.about_attach_mime_type = nil
    respond_to do |format|
      if @user.save
        format.html { redirect_to profile_path(@user), notice: 'Profile was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def handle_upload
    uploaded_attach = params[:user][:about_attach]
    if uploaded_attach.present? && (UPLOAD_CONTENT_TYPES_WHITELIST.include? uploaded_attach.content_type) && (uploaded_attach.tempfile.size < UPLOAD_MAX_FILE_SIZE)
      @user.about_attach = uploaded_attach.read
      # @user.about_attach_filename  = uploaded_attach.original_filename
      @user.about_attach_mime_type = uploaded_attach.content_type
      @user.about_attach_file_size = uploaded_attach.tempfile.size
      return @user.save
    else
      return true
    end
  end
  
  def current_user_is_owner
    raise "[ProfilesController#current_user_is_owner]" if current_user != @user && !current_user.admin?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
  
  def profile_params
    params.require(:user).permit(:about_text, :about_url, :phone) # can't change email, name
  end
end
