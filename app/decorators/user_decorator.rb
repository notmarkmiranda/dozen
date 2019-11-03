class UserDecorator < ApplicationDecorator
  delegate_all

  def full_name_or_email
    object.first_name ? full_name : object.email
  end
  
  private
  
  def full_name
    "#{object.first_name} #{last_initial}".strip
  end
  
  def last_initial
    object.last_name ? object.last_name[0] : ""
  end
end
