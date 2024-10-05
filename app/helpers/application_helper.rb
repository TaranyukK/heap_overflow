module ApplicationHelper
  def flash_messages
    alert_types = {
      notice: 'success',
      alert: 'danger',
      error: 'danger',
      warning: 'warning',
      info: 'info'
    }

    flash.map do |type, message|
      content_tag(:div, message.html_safe, class: "alert alert-#{alert_types[type.to_sym]}")
    end.join.html_safe
  end
end
