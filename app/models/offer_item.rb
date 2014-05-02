class OfferItem < ActiveRecord::Base
  
  belongs_to :offer, inverse_of: :offer_items
  has_many :order_items, dependent: :restrict_with_error
    
  default_scope { order('offer_items.position') }

  STATUSES = [:available, :out_of_stock, :canceled]
  PACKAGING = [["Rinfuza", :bulk], ["Pakiranje", :package], ["Komad varijabilne težine", :vario]]
  
  validates :title, presence: { message: 'cannot be blank' }
  
  validates_presence_of :packaging
  validates_presence_of :decimal_price_bulk, if: :packaging_bulk?
  validates_presence_of :decimal_price_package, if: :packaging_package?
  validates_presence_of :decimal_price_vario, if: :packaging_vario?
  
  # include ActionView::Helpers::NumberHelper
  
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
    OrderQtyCorrector.new(self) if changed_attributes.slice("total_available_qty").any?
  end

  def unit
    self.send("unit_#{packaging}") unless packaging.blank?
  end

    
  def decimal_price
    self.send("decimal_price_#{packaging}")
  end
  
  def decimal_price_bulk
    price_bulk.nil? ? 0.0 : (price_bulk / 100.0)
  end

  def decimal_price_bulk=(input_value)
    self.price_bulk = fcomma(input_value) * 100
  end

  def decimal_price_package
    price_package.nil? ? 0.0 : (price_package / 100.0)
  end

  def decimal_price_package=(input_value)    
    self.price_package = (fcomma(input_value) * 100)
  end

  def decimal_price_vario
    price_vario.nil? ? 0.0 : (price_vario / 100.0) 
  end
  
  def decimal_price_vario=(input_value)
    self.price_vario = (fcomma(input_value) * 100)
  end
  
  # override setter to accept comma for decimal point
  def min_qty_per_order=(input_value)
    write_attribute :min_qty_per_order, fcomma(input_value)
    # this is same as self[:attribute_name] = value
  end
  
  def total_available_qty=(input_value)
    write_attribute :total_available_qty, fcomma(input_value)
  end
  
  # format number with comma as decimal separator to decimal number
  def fcomma(value)
    if value.present?
      value.to_s.gsub(',', '.').to_d
      
      # ne hvata točku kao separator decimala
      # number_with_delimiter(value.to_s, delimiter: "", separator: ",").to_d
    else
      0.0
    end
  end
  
end
