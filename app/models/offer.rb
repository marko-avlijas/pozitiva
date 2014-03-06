class Offer < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  
  attr_accessor :publishing_offer
  
  belongs_to :user
  
  has_many :group_offerings, dependent: :delete_all
  validates :group_offerings, presence: true, if: lambda{ |object| object.publishing_offer.present? }
  
  has_many :groups, through: :group_offerings
  
  has_many :deliveries, inverse_of: :offer, dependent: :destroy 
  accepts_nested_attributes_for :deliveries, allow_destroy: true, reject_if: lambda { |attributes| attributes[:location_id].blank? }  
  validates_associated :deliveries
  validates :deliveries, presence: true, if: lambda{ |object| object.publishing_offer.present? }
  
  has_many :locations, through: :deliveries
  has_many :orders, dependent: :restrict_with_error 

  scope :published, -> { where('offers.valid_from <= ? AND offers.valid_until > ?', Time.current, Time.current).order("offers.created_at DESC") }
  
  validates :title, presence: true
  validates :valid_until, presence: true, if: lambda{ |object| object.publishing_offer.present? }
  validates :valid_from, presence: true, if: lambda{ |object| object.publishing_offer.present? }

  validate :valid_until_cannot_be_greater_than_delivery_date
  def valid_until_cannot_be_greater_than_delivery_date
    if valid_until.present?
      deliveries.each do |delivery| 
        errors.add(:valid_until, "isporuka mora biti nakon roka za narudžbu") if delivery.when && (valid_until > delivery.when)
      end
    end
  end

  validate :valid_until_cannot_be_less_than_valid_from_plus_24_hours
  def valid_until_cannot_be_less_than_valid_from_plus_24_hours
    if valid_until.present?
      errors.add(:valid_until, "period između vremena objave i roka za narudžbu ne smije biti manji od 24 sata") if valid_from && (valid_until < (valid_from + 24.hours))
    end
  end
  
  has_many :offer_items, inverse_of: :offer, dependent: :delete_all  # foreign_key: "offer_id"
  accepts_nested_attributes_for :offer_items, 
    allow_destroy: true, 
    reject_if: lambda { |attributes| attributes[:title].blank? && attributes[:total_available_qty].blank? }
  validates_associated :offer_items
  
  def orders_count_from_user(user)
    orders.where(user_id: user.id).count
  end
  
  def expired?
    status == :finished
  end
  
  def editable?
    status == :draft
  end
  
  def status
    case
    when valid_from.present? && (valid_from <= Time.now) && valid_until.present? && (valid_until >= Time.now)
      :active
    when (valid_until.present?) && (valid_until < Time.now)
      :finished
    else
      :draft
    end
  end
  
  def deactivate
    self.valid_until = Time.now
    self.save!
  end
  
  def duplicate
    kopy = self.dup
    kopy.title = "Kopija ponude #{kopy.title}"
    kopy.valid_from = nil
    kopy.valid_until = nil
    kopy.offer_items << self.offer_items.collect{ |offer_item| offer_item.dup }
    # kopy.deliveries << self.deliveries.collect{ |delivery| delivery.dup }
    # kopy.group_offerings << self.group_offerings.collect{ |group_offering| group_offering.dup }
    kopy.save ? kopy : nil
  end
  
  def handle_attach(uploaded_attach)
    if uploaded_attach.present?
      if UPLOAD_CONTENT_TYPES_WHITELIST.include?(uploaded_attach.content_type) && (uploaded_attach.tempfile.size <= UPLOAD_MAX_FILE_SIZE)
        self.attach = uploaded_attach.read
        # self.filename  = uploaded_attach.original_filename
        self.attach_mime_type = uploaded_attach.content_type
        self.attach_file_size = uploaded_attach.tempfile.size
        self.save
      else
        errors.add(:attach, "Dozvoljen je samo PDF dokument manji od #{number_to_human_size(UPLOAD_MAX_FILE_SIZE)}")
        return false
      end
    else
      return true
    end
  end
end
