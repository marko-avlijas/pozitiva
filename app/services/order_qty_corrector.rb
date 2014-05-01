class OrderQtyCorrector

  # TODO raspodjela ne manje od min_količine za bulk
  
  def initialize(offer_item)
    if offer_item.total_available_qty.present?
      @total_available_qty = offer_item.total_available_qty
      @remain_qty = offer_item.total_available_qty
      @order_items = offer_item.order_items.order("order_items.created_at DESC")
      @order_items.each{ |order_item| order_item.corrected_qty = 0 }    
      
      if offer_item.packaging_bulk?
        calculate_packaging_bulk
        @order_items.each{ |order_item| order_item.save! if order_item.changed? }
        
      elsif offer_item.packaging_package?
        calculate_packaging_package
      end  
    end
  end
  
  private
  
  def calculate_packaging_package
    if @order_items.size > 0
      while @remain_qty > 0
        @order_items.each do |order_item| 
          if (@remain_qty > 0) && (order_item.qty - order_item.corrected_qty.to_i) > 0
            order_item.corrected_qty = order_item.corrected_qty.to_i + 1
            @remain_qty -= 1
            order_item.save!
          end
        end
      end
    end
  end
  
  def calculate_packaging_bulk
    if @order_items.size > 0
      while (@remain_qty > 0.01) && (qty_diff > 0.01)

        # divide in equal chunks for all
        available_qty_to_add = @remain_qty / @order_items.size
      
        @order_items.each do |order_item| 
          wants = (order_item.qty - order_item.corrected_qty)
          if wants <= available_qty_to_add
            # can have all that wants
            order_item.corrected_qty += wants
            @remain_qty -= wants
          else
            # wants too much, can get only available_qty_to_add
            order_item.corrected_qty += available_qty_to_add
            @remain_qty -= available_qty_to_add
          end
          # Rails.logger.debug "id: #{order_item.id}, corrected_qty: #{order_item.corrected_qty.to_s}"
        end
        
      end # of while
      
      # Rails.logger.debug "diff: #{@total_available_qty - @order_items.to_a.sum{|i| i.corrected_qty.round(1)}}" 
      if available_qty_diff < 0
        @order_items.each { |order_item| order_item.corrected_qty -= 0.1 if (order_item.corrected_qty.round(1) > order_item.corrected_qty) }
      end
    end
  end
    
  def available_qty_diff
    @total_available_qty - @order_items.to_a.sum{ |i| i.corrected_qty.round(1) }
  end
  
  def qty_diff
    @order_items.to_a.sum(&:qty) - @order_items.to_a.sum(&:corrected_qty)
  end

end