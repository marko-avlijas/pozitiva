class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:help, :manifest]
  
  def home
    flash.now[:notice] = "Registracija u aplikaciju je u tijeku - obavijest o uspješnoj registraciji primit ćete mailom." if current_user.try(:group).blank?
    @current_user_is_admin = current_user.admin?
  end
  
  def info_gsr_pozitiva
    if current_user.group.title != "GSR Pozitiva"
      redirect_to :root, alert: "samo za članove grupe GSR Pozitiva"
    end
  end
  
  def info_gsr_puslek
    if current_user.group.title != "GSR Pušlek"
      redirect_to :root, alert: "samo za članove grupe GSR Pušlek"
    end
  end

end
