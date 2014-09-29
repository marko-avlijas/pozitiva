require 'open-uri'

class User < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  #  :timeoutable and :omniauthable
  
  # config/initializers/devise.rb  line config.unlock_strategy = :none
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :lockable
    
  belongs_to :group, inverse_of: :users
  has_many :offers, inverse_of: :user, dependent: :restrict_with_error 
  has_many :orders, inverse_of: :user, dependent: :restrict_with_error 
  
  validates :name, :phone, presence: { message: 'obavezno upisati' }
  validates :requested_group_id, presence: { message: 'obavezno odabrati' }, if: :group_blank?
  # validates :name, uniqueness: { message: 'u upotrebi' }
  validates :buyer_tag, uniqueness: { message: 'u upotrebi' }, allow_blank: true
  
  default_scope { order('users.id DESC') }
  
  after_create do
    NotificationsMailer.new_user_registration_to_admins(self).deliver
  end
  
  after_save do
    if changed_attributes.slice("group_id").any?
      message = Message.new(subject: "Upis u grupu", body: "Dobrodošli u web-aplikaciju Njam-Njam! Registrirani ste kao član grupe #{group.title}. Aplikaciji pristupite putem linka: http://pozitiva.herokuapp.com . Ukoliko ste vlasnik ove e-mail adrese, a ne sjećate se da ste se registrirali u Njam-Njam aplikaciju, možda je došlo do neke greške pa nas što prije kontaktirajte na njamnjam.app@gmail.com ") 
      NotificationsMailer.admin_message_to_user(self, message).deliver
    end
  end
  
  def admin?
    self.admin
  end
  
  def group_blank?
    self.group.blank?
  end
  
  def avatar_src
    avatar.present? ? "data:image/jpg;base64,#{Base64.encode64(avatar)}" : 'user.png'    
  end
  
  def download_avatar(url)
    return true if url.blank?
    aviary_image = open(url)
    if aviary_image.status.first.to_i == 200 # => ["200", "OK"]
      self.avatar = aviary_image.read
      self.avatar_mime_type = aviary_image.meta["content-type"]
      # aviary_image.meta["content-length"]  # bytes
    end
  end
  
  def handle_about_attach(attachment)
    return true if attachment.blank?
    if UploadValidator.new(self, :about_attach, attachment, :pdf).valid?    
      self.about_attach = attachment.read
      # self.filename  = attachment.original_filename
      self.about_attach_mime_type = attachment.content_type
      self.about_attach_file_size = attachment.tempfile.size
      true
    else
      false
    end
  rescue => e
    errors.add(:base, "Attachment upload error: #{e}")
    false
  end

end
