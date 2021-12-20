class ViewBpTimeOnly  < ApplicationRecord
  self.primary_key = :id

  belongs_to :blood_pressure

  def readonly?
    true
  end
end

# Following https://roberteshleman.com/blog/2014/09/18/using-postgres-views-with-rails/ and https://www.netguru.com/blog/database-views-and-how-to-use-them-in-a-ror-based-app
