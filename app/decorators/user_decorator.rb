class UserDecorator < ApplicationDecorator
  delegate_all

  def full_name_or_email
    object.first_name ? full_name : object.email
  end

  def full_name
    return object.email if object.first_name.blank?
    "#{object.first_name} #{last_initial}".strip
  end

  private

  def last_initial
    object.last_name ? object.last_name[0] : ""
  end
end
