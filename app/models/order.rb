class Order < ActiveRecord::Base
  belongs_to :user, inverse_of: :orders
  validates :user, presence: true
  
  belongs_to :offer
  validates :offer, presence: true
  
  belongs_to :delivery  
  validates :delivery, presence: true

  has_many :order_items, inverse_of: :order, dependent: :delete_all
  
  accepts_nested_attributes_for :order_items, 
    allow_destroy: true, 
    reject_if: lambda { |order_item| 
      (order_item[:qty].to_s.gsub(',','.').to_d == 0.0) && 
      order_item[:qty_description].blank? && 
      (order_item[:corrected_qty].blank? || order_item[:corrected_qty].to_d == 0.0) && order_item[:id].blank?
    }
  
  validates :order_items, presence: { message: 'ništa nije naručeno (neispravan unos količine)'}
  
  def find_or_build_order_item_for(offer_item)
    order_items.find{ |order_item| order_item.offer_item_id == offer_item.id } || order_items.build(offer_item_id: offer_item.id)
  end
  

  def self.to_csv(options = {})
    
    header_cols = ["order_item_id", "offer_item_id",  "title", "pakiranje", "jed.cijena_kn", "NARUČENA KOL", "opis_vario", "ISPORUČENA KOL", "NARUČITELJ_grupa", "NARUČITELJ_tag", "NARUČITELJ_ime"]
    
    require 'csv'
    CSV.generate(options) do |csv|
      csv << header_cols
      all.each do |order|
        order.order_items.each do |order_item|
          csv << [
            order_item.id, 
            order_item.offer_item_id, 
            order_item.offer_item.title, 
            order_item.offer_item.unit, 
            order_item.offer_item.decimal_price.to_s,
            order_item.qty.to_s,
            order_item.qty_description,
            order_item.numeric_qty.to_s,
            order_item.order.user.group.title,
            order_item.order.user.buyer_tag,
            order_item.order.user.name
          ]
        end
      end            
    end
  end
  
end
