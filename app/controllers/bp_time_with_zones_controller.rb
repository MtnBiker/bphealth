class ViewBpTimeWithZone < ApplicationController
  def index
    @view_bp_time_with_zones = ViewBpTimeWithZone.all.order("stattime") # Same with or without this.  data in table is sorted by statdate
  end
end
