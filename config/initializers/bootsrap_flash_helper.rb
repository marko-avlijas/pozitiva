module BetterBootstrapFlashHelper
  # https://coderwall.com/p/x3keqg
  ALERT_TYPES = [:error, :info, :success, :warning]

  def bootstrap_application_flash
    flash_messages = []
    alert_result_types = {:error => [], :info => [], :success => [], :warning => []}
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type == :notice
      type = :error if type == :alert
      next unless ALERT_TYPES.include?(type)
      Array(message).each do |msg|
        alert_result_types[type] << content_tag(:li, msg.html_safe) if msg
      end
    end
    alert_result_types.each do |key, content|
      flash_messages << generate_alert(key, content_tag(:ul, content.join.html_safe, :class => 'unstyled')) if content.length > 0
    end
    flash_messages.join.html_safe
  end

  def generate_alert(type, messages)
    content_tag(:div,content_tag(:button, raw("&times;"), class: "close", "data-dismiss" => "alert") + messages, class: "alert fade in alert-#{type}")
  end

end
