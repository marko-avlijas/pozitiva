class OrderItem < ActiveRecord::Base
  belongs_to :order, inverse_of: :order_items
  validates :order, presence: true
  
  belongs_to :offer_item
  validates :offer_item, presence: true
  default_scope { order('order_items.id DESC') }
  
  # include ActionView::Helpers::NumberHelper
  
  # validates_numericality_of :qty, only_integer: true, 
  #   message: 'upisati cijeli broj jer se radi o pakiranju', 
  #   if: :qty_have_to_be_integer?

  validate :qty_package_has_to_be_integer, if: :qty_have_to_be_integer?
  def qty_package_has_to_be_integer
    if (qty.to_i < qty.to_d)
      errors.add(:qty, "upisati cijeli broj jer se radi o pakiranju")
    end
  end
  
  def qty_have_to_be_integer?
    self.offer_item.packaging == "package"
  end

  validates :qty_description, presence: true, if: :qty_description_required?
  def qty_description_required?
    self.offer_item.packaging == "vario"
  end
  
  validate :qty_is_not_less_than_min_qty_per_order
  def qty_is_not_less_than_min_qty_per_order
    if qty && offer_item.min_qty_per_order && (qty.to_d < offer_item.min_qty_per_order.to_d)
      errors.add(:qty, "Naručena količina ne smije biti manja od Minimalne količine")
    end
  end
  
  def numeric_qty
    if corrected_qty
      # if qty_have_to_be_integer?
        # corrected_qty.to_i
      # else
        corrected_qty
      # end
    else # use qty
      return 0 if qty.nil?
      # if qty_have_to_be_integer?
      #   qty.to_i
      # else
        qty
      # end
    end
  end
  
  def item_price
    numeric_qty.to_d * self.offer_item.decimal_price
  end

  
  # override setter (accept comma for decimal point)
  def qty=(value)
    # if qty_have_to_be_integer?
    #   write_attribute(:qty, value.to_s.to_i)
    # else
      # write_attribute(:qty, value.to_s.gsub(',', '.').to_d)
      # write_attribute(:qty, number_with_delimiter(value.to_s, delimiter: "", separator: ","))
      write_attribute :qty, value.to_s.gsub(',', '.').to_d
      
      # this is same as self[:qty] = value
    # end
  end
  
  def corrected_qty=(value)
    # write_attribute(:corrected_qty, value.to_s.gsub(',', '.').to_d)
    # write_attribute(:corrected_qty, number_with_delimiter(value.to_s, delimiter: "", separator: ","))
    write_attribute :corrected_qty, value.to_s.gsub(',', '.')
  end
end
