class Admin::CleanupController < ApplicationController
  before_action :current_user_is_admin
  
  def clean_older_than
    older_than = params["older_than"].to_i
    if older_than > 1
      offers = Offer.where("valid_until < ?", Time.current - older_than.months)
      offers_count = offers.count
      offers.each do |offer|
        offer.orders.destroy_all
      end
      offers.destroy_all
      redirect_to admin_offers_path, notice: "Broj izbrisanih ponuda starijih od #{older_than} mjeseca: #{offers_count}"
    else
      redirect_to admin_offers_path, alert: "Mogu se brisati samo ponude starije od 2 mjeseca"
    end
  end

end