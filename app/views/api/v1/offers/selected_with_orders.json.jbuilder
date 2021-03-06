json.array! @offers do |offer|
  json.id             offer.id
  json.user_name      offer.user.name
  json.user_email     offer.user.email
  json.user_group     offer.user.group.title
  json.groups         offer.groups.pluck(:title)
  json.delivery_dates offer.deliveries.pluck(:when)

  json.orders offer.orders do |order|
    json.id         order.id
    json.user_name  order.user.name
    json.user_email order.user.email
    json.user_group order.user.group.title

    json.order_items order.order_items.order(:offer_item_id) do |order_item|
      json.id              order_item.id
      json.offer_title     order_item.offer_item.title
      json.packaging       order_item.offer_item.packaging
      json.unit            order_item.offer_item.unit
      json.qty             order_item.qty
      json.qty_description order_item.qty_description
      json.corrected_qty   order_item.corrected_qty
    end
  end
end
