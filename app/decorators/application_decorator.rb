class ApplicationDecorator < Draper::Decorator
  def date_and_year(date)
    date.strftime('%B %Y')
  end

  def full_date_and_time(date)
    date.strftime('%B %-e, %Y at %l:%M %p')
  end

  def full_date(date)
    date.strftime('%B %-e, %Y')
  end
end
