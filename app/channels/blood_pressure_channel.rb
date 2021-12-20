class BloodPressureChannel < ApplicationCable::Channel
  def subscribed
    stream_from "blood_pressure_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
