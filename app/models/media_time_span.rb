# frozen_string_literal: true

class MediaTimeSpan < ApplicationRecord
  belongs_to :media_manage

  def begin_time_str
    sec_to_str(begin_sec)
  end

  def end_time_str
    sec_to_str(end_sec)
  end

  private

  def sec_to_str(sec_org)
    sec = sec_org
    hour = sec / 3600
    sec = sec % 3600
    min = sec / 60
    sec = sec % 60
    format('%<hour>02d:%<min>02d:%<sec>02d',
           hour: hour, min: min, sec: sec)
  end
end
