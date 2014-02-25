class OfferItemOrders
  
  def initialize(offer, orders)
    @offer = offer
    initialize_sum_hash_for(orders)
    calculate_qty_sum
    fill_in_numeric_qty_sum
  end
  
  def get_sum_hash
    @sum_hash
  end
  
  private
  def initialize_sum_hash_for(orders)
    @sum_hash = {}
    orders.each do |order| 
      order.order_items.each do |order_item| 
        if order_item.offer_item 
          @sum_hash[order_item.offer_item_id] = { 
            title: order_item.offer_item.title, 
            unit:  order_item.offer_item.unit, 
            price: order_item.offer_item.decimal_price, 
            icon:  order_item.offer_item.packaging } 
        end  
      end 
    end
  end
  
  def calculate_qty_sum
    offer_orders_sum = @offer.orders.includes(:order_items).group(:offer_item_id).sum(:qty)
    offer_orders_sum.each do |id, qty_sum| 
      @sum_hash[id][:qty_sum] = qty_sum.to_d
    end    
  end
  
  def fill_in_numeric_qty_sum
    @offer.orders.includes(:order_items).to_a.each do |order|       
      order.order_items.each do |order_item| 
        id = order_item.offer_item_id
        if @sum_hash[id][:numeric_qty_sum]
          @sum_hash[id][:numeric_qty_sum] += order_item.numeric_qty.to_d
        else
          @sum_hash[id][:numeric_qty_sum] = order_item.numeric_qty.to_d
        end
      end
    end
  end

end