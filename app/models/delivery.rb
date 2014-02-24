class Delivery < ActiveRecord::Base
  belongs_to :offer
  validates :offer, presence: true
  
  belongs_to :location
  validates :location, presence: true
  
end
