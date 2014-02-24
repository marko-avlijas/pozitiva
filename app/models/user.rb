class User < ActiveRecord::Base
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
      message = Message.new(subject: "Upis u grupu", body: "Dobrodošli u web-aplikaciju PozitivaHub! Registrirani ste kao član grupe #{group.title}. Aplikaciji pristupite putem linka: http://pozitiva.herokuapp.com. Ukoliko ste vlasnik ove e-mail adrese, a ne sjećate se da ste se registrirali u PozitivaHub aplikaciju, možda je došlo do neke greške pa nas što prije kontaktirajte na pozitiva.gsr@gmail.com ") 
      NotificationsMailer.admin_message_to_user(self, message).deliver
    end
  end
  
  def admin?
    self.admin
  end
  
  def group_blank?
    self.group.blank?
  end
end
