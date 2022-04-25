class BloodPressure < ApplicationRecord

  # iOS Health has all values and don't want to reenter them with each export/import. Would wipe out comments
  # So the following validation is preventing duplicating or overwriting the database when importing the same data again, but not giving me grief with inline updating
  # I think this also now exists in Postgres
  validates :statdate,  uniqueness: {scope: [:statdate, :systolic, :diastolic], message: "Already imported"}

  has_one :bp_time_with_zone # SWAG to turn off and see if heroku push works. Didn't help
end
