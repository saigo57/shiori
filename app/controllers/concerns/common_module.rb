# frozen_string_literal: true

module CommonModule
  extend ActiveSupport::Concern

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
