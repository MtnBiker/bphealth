module BloodPressuresHelper
  def systolic_text_color (systolic)
    case systolic
    when 0..120
      "text-success"
    when 121..139
      "text-warning"
    when 140..150
      "text-danger"
    when 151..200
      "text-danger font-weight-bold" # should be danger, but using as a test to see if this method being used
    else
      "text-secondary " # if this shows up something not working right
    end
  end # systolic_text_color

  def systolic_icon_level (systolic)
    case systolic
    when 0..120
     "bi bi-emoji-smile"
    when 121..139
      "bi bi-emoji-neutral"
    when 140..150
      "bi bi-emoji-frown"
    when 151..220
      "bi bi-emoji-frown-fill"
      # "bi bi-emoji-angry"
    else
       "bi bi-question-lg"
    end
  end # systolic_icon_level

  def vert_lines (day_num)
    vert_lines = ""
    char = "|"
    case day_num
      when 0 then "|"
      when 1 then "||"
      when 2 then "||"
      when 3 then "||||"
      when 4 then "|||||"
        # if put in blank, the line wraps, same for &nbsp;, hence the period
      when 5 then "|||||.|"
      when 6 then "|||||.||"
    end
  end
end
