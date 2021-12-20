module BloodPressuresHelper
  def systolic_text_color (systolic)
    case systolic
    when 0..120
      "text-success"
    when 121..139
      "text-warning"
    when 139..150
      "text-danger"
    when 151..200
      "text-danger font-weight-bold" # should be danger, but using as a test to see if this method being used
    else
      "text-secondary " # if this shows up something not working right
    end
  end # systolic_text_color
  
end
