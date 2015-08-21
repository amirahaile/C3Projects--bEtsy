module ApplicationHelper
  def readable_date(datetime)
    datetime.strftime("%b %d, %Y")
  end
end
