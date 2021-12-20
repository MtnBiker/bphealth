class BpTimeOnly < ApplicationController
  def index
   # view_bp_time_onlies name of view
    @view_bp_time_onlies = ViewBpTimeOnly.all.order("stattime")
  end
end
# SWAG