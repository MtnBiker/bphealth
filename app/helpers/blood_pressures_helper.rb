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

  # https://www.seancdavis.com/posts/render-inline-svg-rails-middleman/
  def svg(name)
    file_path = "#{Rails.root}/app/assets/images/#{name}.svg"
    return File.read(file_path).html_safe if File.exists?(file_path)
    fallback_path = "#{Rails.root}/app/assets/images/png/#{name}.png"
    return image_tag("png/#{name}.png") if File.exists?(fallback_path)
    '(not found)'
  end

end
