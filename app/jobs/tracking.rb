module Tracking

  @queue = :package

  def perform(package)
    package.update_tracking_information
  end
end
