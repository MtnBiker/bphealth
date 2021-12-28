class BpTimeWithZone < ApplicationController
  def index
    @bp_time_with_zones = BpTimeWithZone.all.order("stattime") # Same with or without this.  data in table is sorted by statdate
  end
end

# bp_time_with_zones_controller.rb:1:in `<main>': superclass mismatch for class ViewBpTimeWithZone (TypeError)
