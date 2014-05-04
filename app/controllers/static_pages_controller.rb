class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:help, :manifest]
  
  def home
    flash.now[:notice] = "Registracija u aplikaciju je u tijeku - obavijest o uspješnoj registraciji primit ćete mailom." if current_user.try(:group).blank?
    @current_user_is_admin = current_user.admin?
  end

  def help
  end
  
  def manifest
  end
end
