class BloodPressure < ApplicationRecord
  # iOS Health has all values and don't want to reenter them with each export/import. Would wipe out comments
  validates :statdate,  uniqueness: {scope: [:statdate, :systolic, :diastolic ]}
  has_one :bp_time_with_zone
end
