class Admin::ExportController < ApplicationController
  layout 'table', only: [:index]
  # before_filter :seed_admin
  before_action :current_user_is_admin
  
  def index
    @order_items = OrderItem.includes(order: :user).includes(offer_item: { offer: :user }).all
  end
  
end