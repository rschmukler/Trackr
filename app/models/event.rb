class Event < ActiveRecord::Base
  belongs_to :package

  def location
    "#{city.capitalize}, #{state.capitalize}"
  end
end
