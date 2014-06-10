class Admin::ExportController < ApplicationController
  layout 'export', only: [:index]
  before_action :current_user_is_admin
  
  def index
    if params[:group_id].present? && params[:start_date].present? && params[:end_date].present?
      if params[:commit] == "Generiraj tablicu"
        @order_items = OrderItem.joins(order: {user: :group}).joins(order: :delivery).includes(offer_item: { offer: :user }).where("groups.id = ?", params[:group_id].to_i).where("deliveries.when >= ? AND deliveries.when <= ?", params[:start_date], params[:end_date].to_date+1.day)
      else
        @offer_items_without_orders = OfferItem.where("offer_items.id not in (select order_items.offer_item_id from order_items)").includes(offer: :user)
      end
    end
    
  end
  
end