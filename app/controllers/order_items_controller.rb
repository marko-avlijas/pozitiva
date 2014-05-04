class OrderItemsController < ApplicationController
  before_action :set_order_item, :current_user_can_write

  # DELETE /orders/1
  def destroy
    @order_item.destroy
    if @order.order_items.any?
      redirect_to edit_offer_order_path(@order.offer, @order), notice: 'Stavka je uspješno izbrisana.'
    else
      @order.destroy
      redirect_to my_orders_path, notice: 'Brisanjem zadnje stavke izbrisali ste cijelu narudžbu. Ukoliko ipak želite nešto naručiti, morate kreirati novu narudžbu.'
    end
  end

  private
  
  def order_from_current_user?
    current_user.orders.exists?(id: params[:order_id])
  end
  
  def current_user_can_write
    raise "[OrderItemsController#current_user_can_write]" unless order_from_current_user?
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id])
    @order = @order_item.order
  end

end
