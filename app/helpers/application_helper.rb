# encoding: UTF-8

module ApplicationHelper

  MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                        'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                        'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                        'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                        'webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|' +
                        'mobile|zune'
  def mobile_device?
    request.user_agent.to_s.downcase =~ Regexp.new(MOBILE_USER_AGENTS)
  end
  
  def error_messages_for(*objects)
    options = objects.extract_options!
    options[:header_message] ||= I18n.t(:"activerecord.errors.header", default: "Invalid Fields")
    # options[:message] ||= I18n.t(:"activerecord.errors.message", default: "Correct the following errors and try again.")
    messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    unless messages.empty?
      content_tag(:div, id: "error_explanation", class: "error_messages") do
        list_items = messages.map { |msg| content_tag(:li, msg) }
        # content_tag(:h2, options[:header_message]) + content_tag(:p, options[:message]) + content_tag(:ul, list_items.join.html_safe)
        content_tag(:h2, options[:header_message]) + content_tag(:ul, list_items.join.html_safe)
      end
    end
  end
  
  def li_active_if_current(title, path)    
    if current_page? path
      content_tag :li, link_to(title, path), class: "active"
    else
      content_tag :li, link_to(title, path)
    end
  end

  def offer_item_packaging_icon(offer_item_packaging)
    case offer_item_packaging
    when "package"
      content_tag :i, nil, class: "fa fa-gift"
    when "bulk"
      content_tag :i, nil, class: "fa fa-tachometer"
    when "vario"
      content_tag :i, nil, class: "fa fa-question-circle"
    else
      ""
    end
  end
  
  def offer_item_packaging_unit(offer_item)
    case offer_item.packaging
    when "package"
      content_tag :span, "kom", class: "input-group-addon"
    when "bulk", "vario"
      content_tag :span, offer_item.unit, class: "input-group-addon"
    else
      ""
    end
  end
  
  def offer_item_packaging_unit_alert(offer_item)
    case offer_item.packaging
    when "package"
      content_tag :span, "kom", class: "input-group-addon limited"
    when "bulk"
      content_tag :span, offer_item.unit, class: "input-group-addon limited"
    when "vario"
      ""
    else
      ""
    end
  end
  
  def offer_item_quantity_for_price(offer_item)
    case offer_item.packaging
    when "bulk", "vario"
       "1#{offer_item.unit} = #{formatted_price offer_item.decimal_price}"
    when "package"
      "#{offer_item.unit} = #{formatted_price offer_item.decimal_price}"
    else
      ""
    end
  end
  
  def badge_status(offer)
    offer_status = offer.status
    case offer_status
    when :draft
      content_tag :span, t(offer_status), class: "badge blue"
    when :active
      # content_tag :span, t(offer_status), class: "badge"
      content_tag :span, "još #{distance_of_time_in_words_to_now offer.valid_until}" , class: "badge"
      
    when :finished
      content_tag :span, t(offer_status), class: "badge grey"
    else
      content_tag :span, t(offer_status), class: "badge grey"
    end
  end
  
  def offer_item_packaging_min_qty(offer_item)
    # return "-" if offer_item.min_qty_per_order.blank? || offer_item.min_qty_per_order.to_d == 0.0
    case offer_item.packaging
    when "bulk"
      "Min.: #{formatted_qty offer_item.min_qty_per_order} #{offer_item.unit}" if offer_item.min_qty_per_order > 0
    else
      ""
    end if offer_item.min_qty_per_order
  end
  
  def formatted_qty(qty)
    return 0 if qty.nil?
    # qty_d = qty.to_s.gsub(',', '.').to_d
    # (qty_d.to_int < qty) ? qty_d.to_s.gsub('.', ',') : qty_d.to_int
    
    (qty.to_int < qty) ? qty.to_s.gsub('.', ',') : qty.to_int
  end
  
  def formatted_item_qty_unit(item)
    case item.offer_item.packaging
    when "bulk"
      out = "#{formatted_qty item.qty} #{item.offer_item.unit}"
    when "vario"
      out = "#{item.qty_description}"
    else
      out = "#{formatted_qty item.qty} x #{item.offer_item.unit}"
    end
    item.corrected_qty.present? ? content_tag(:span, "(#{out})", style: 'text-decoration: line-through') : out
  end
  
  def formatted_item_corrected_qty_unit(item)
    if item.corrected_qty.blank? 
      if item.offer_item.packaging == "vario"
        return content_tag :i, nil, class: "fa fa-question-circle"
      else 
        return formatted_item_qty_unit(item)
      end
    end
    case item.offer_item.packaging
    when "bulk", "vario"
      "#{formatted_qty item.corrected_qty} #{item.offer_item.unit}"
    else
      "#{formatted_qty item.corrected_qty} x #{item.offer_item.unit}"
    end
  end
    
  def formatted_item_numeric_qty_unit(item)
    case item.offer_item.packaging
    when "bulk"
      "#{formatted_qty item.numeric_qty} #{item.offer_item.unit}"
      
    when"vario"
      if item.corrected_qty.blank?
        item.qty_description
      else
        "#{formatted_qty item.numeric_qty} #{item.offer_item.unit}"
      end
      
    else
      "#{formatted_qty item.numeric_qty} x #{item.offer_item.unit}"
    end
  end
  
  def formatted_price(price)
    # price.blank? ? '-' : "#{sprintf("%.2f", price).gsub('.', ',')} kn" 
    price.blank? ? '-' : number_to_currency(price)    
  end

  def vario_price_unknown(order_item)
    if order_item.corrected_qty.blank? && order_item.offer_item.packaging == "vario"
      content_tag :i, nil, class: "fa fa-question-circle"
    else 
      formatted_price(order_item.item_price)
    end
  end

  def vario_qty_unknown(order_item)
    if order_item.corrected_qty.blank? && order_item.offer_item.packaging == "vario"
      content_tag :i, nil, class: "fa fa-question-circle"
    else 
      order_item.corrected_qty
    end
  end

  def formatted_dt(dt)
    dt ? l(dt, format: "%A %d.%m.%Y %k:%M") : '-'
  end

  def short_dt(dt)
    dt ? l(dt, format: "%d.%m.%Y %k:%M") : '-'
  end

  def dt_picker(dt)
    dt ? l(dt, format: "%d. %m. %Y %k:%M") : ''
  end

  def formatted_valid_from(offer)
    offer.try(:valid_from) ? l(offer.valid_from, format: "%A %d.%m.%Y %k:%M") : content_tag(:span, 'nije određeno')
  end
  
  def formatted_valid_until(offer)
    offer.try(:valid_until) ? l(offer.valid_until, format: "%A %d.%m.%Y %k:%M") : 'nije određeno'
  end
  
  def formatted_delivery_when(delivery)
    l(delivery.when, format: "%A %d.%m.%Y %k:%M") if delivery.when
  end
  
  def formatted_delivery_when_date(delivery)
    l(delivery.when, format: "%A %d.%m.%Y") if delivery.when
  end
  
  def formatted_delivery_when_time(delivery)
    l(delivery.when, format: "%k:%M") if delivery.when
  end
  
  def display_order(order)
    "#{order.user.name} (#{order.user.group.title}) isporuka #{badge_delivery order}"
  end
  
  def badge_delivery(order)
    location = order.delivery.location.title if order && order.try(:delivery) && order.delivery.try(:location)
    time = "u #{formatted_delivery_when order.delivery}" if order.try(:delivery) && order.delivery.try(:when)
    grey = "grey" if order.delivery.when && order.delivery.when < Time.current
    blue = "blue" if order.delivery.when.blank?
    content_tag :span, "#{location} #{time}" , class: "badge #{grey} #{blue}"
  end
  
end
