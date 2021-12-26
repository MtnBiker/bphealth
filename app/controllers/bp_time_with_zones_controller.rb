class ViewBpTimeWithZonesController < ApplicationController
  def index
    @view_bp_time_with_zones = ViewBpTimeWithZone.all.order("stattime") # Same with or without this.  data in table is sorted by statdate
  end
end

# expected file /tmp/build_b81ece36/app/controllers/bp_time_with_zones_controller.rb to define constant BpTimeWithZonesController, but didn't (Zeitwerk::NameError)