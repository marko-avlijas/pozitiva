class NotificationsMailer < ActionMailer::Base
  default from: "pozitiva.gsr@gmail.com" # "noreply@pozitiva.herokuapp.com"
  # default to: "you@youremail.dev"

  def message_to_user(from_user, to_user, message)
    @message = message
    @from_user = from_user
    mail(from: from_user.email, reply_to: from_user.email, to: to_user.email, subject: "[PozitivaHub] #{message.subject}") unless to_user.email.blank?
  end

  def admin_message_to_user(to_user, message)
    @message = message
    mail(to: to_user.email, subject: "[PozitivaHub] #{message.subject}") unless to_user.email.blank?
  end

  def message_to_orderers(from_user, offer, message)
    @message = message
    @from_user = from_user
    @offer = offer
    orderers_emails = offer.orders.map{ |order| order.user.email }.compact.uniq
    mail(from: from_user.email, reply_to: from_user.email, to: orderers_emails.join(', '), subject: "[PozitivaHub] #{message.subject}") unless orderers_emails.blank?
  end

  def new_user_registration_to_admins(user)
    @user = user
    admins_emails = User.where(admin: true).pluck(:email).to_a.compact
    mail(to: admins_emails.join(', '), subject: "[PozitivaHub] Nova Registracija") unless admins_emails.empty?
  end
  
end
