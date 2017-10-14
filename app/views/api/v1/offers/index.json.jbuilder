json.array! @offers do |offer|
  # ID
  # Ponuđač
  # Ponuda
  # Za grupu
  # Isporuka
  # Vrijedi od
  # Vrijedi do
  # Status
  # Narudžbe

  json.id         offer.id
  json.user_name  offer.user.name
  json.user_email offer.user.email
  json.title      offer.title
  json.groups     offer.groups.map{ |g| g.title }

  json.deliveries offer.deliveries do |delivery|
    json.when           delivery.when
    json.location_title delivery.location.title
  end

  json.valid_from   offer.valid_from
  json.valid_until  offer.valid_until
  json.status       offer.status
  json.orders_count offer.orders.count
end
