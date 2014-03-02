class OfferItem < ActiveRecord::Base
  
  belongs_to :offer, inverse_of: :offer_items
  has_many :order_items, dependent: :restrict_with_error
    
  default_scope { order('offer_items.created_at') }

  STATUSES = [:available, :out_of_stock, :canceled]
  PACKAGING = [["Rinfuza", :bulk], ["Pakiranje", :package], ["Komad varijabilne težine", :vario]]
  
  validates :title, presence: { message: 'cannot be blank' }
  
  validates_presence_of :packaging
  validates_presence_of :decimal_price_bulk, if: :packaging_bulk?
  validates_presence_of :decimal_price_package, if: :packaging_package?
  validates_presence_of :decimal_price_vario, if: :packaging_vario?
  
  def packaging_bulk?
    packaging == 'bulk'
  end
  
  def packaging_package?
    packaging == 'package'
  end
  
  def packaging_vario?
    packaging == 'vario'
  end
  
  after_save do
    if changed_attributes.slice("total_available_qty").any?
      OfferItemCalculator.new(self).calculate_corrected_qty_for_order_items
      self.order_items.each{ |order_item| order_item.save! if order_item.changed? }
    end
  end

  def unit
    self.send("unit_#{packaging}") unless packaging.blank?
  end

  # override setter to accept comma for decimal point
  def min_qty_per_order=(value)
    write_attribute(:min_qty_per_order, value.to_s.gsub(',', '.').to_d)
    # this is same as self[:attribute_name] = value
  end
    
  def decimal_price
    self.send("decimal_price_#{packaging}") unless packaging.blank?
  end
  
  def decimal_price_bulk
    price_bulk.nil? ? 0.0 : price_bulk.to_d/100 
  end

  def decimal_price_bulk=(input_value)
    self.price_bulk = input_value.to_s.gsub(',', '.').to_d * 100 if input_value.present?
  end

  def decimal_price_package
    price_package.nil? ? 0.0 : price_package.to_d/100
  end

  def decimal_price_package=(input_value)
    self.price_package = input_value.to_s.gsub(',', '.').to_d * 100 if input_value.present?
  end

  def decimal_price_vario
    price_vario.nil? ? 0.0 : price_vario.to_d / 100    
  end

  def decimal_price_vario=(input_value)
    self.price_vario = input_value.to_s.gsub(',', '.').to_d * 100 if input_value.present?
  end
  
  def total_available_qty=(input_value)
    write_attribute(:total_available_qty, input_value.to_s.gsub(',', '.').to_d)
  end
  
end
