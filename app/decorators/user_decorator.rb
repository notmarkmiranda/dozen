class UserDecorator < ApplicationDecorator
  delegate_all

  def full_name_or_email
    object.first_name ? full_name : object.email
  end

  def full_name
    return object.email if object.first_name.blank?
    "#{object.first_name} #{object.last_name}".strip
  end
end
