# app/helpers/time_helper.rb
module TimeHelper
  def format_time(time, format = "MMMM d, yyyy h:mma")
    content_tag(
        :span,
        time,
        data: { "time-format": format, "time-value": time.to_json }
    )
  end

  def relative_time(time)
    format_time(time, :relative)
  end

  def year(time)
    format_time(time, "yyyy")
  end
end