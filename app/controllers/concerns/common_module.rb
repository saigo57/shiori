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

  def extract_youtube_id(url)
    return if url.nil?

    reg = url.match(%r{https://youtu\.be/(?<id>.+?)\z})
    return reg[:id] unless reg.nil?

    reg = url.match(%r{https://www\.youtube\.com/watch\?(?<param>.+?)\z})

    unless reg.nil?
      reg[:param].split('&').each do |p|
        arr = p.split('=')
        next if arr.size != 2
        return arr[1] if arr[0] == 'v'
      end
    end

    nil
  end

  def build_youtube_url(youtube_id, sec = nil)
    url = "https://www.youtube.com/watch?v=#{youtube_id}"
    return url if sec.nil?

    "#{url}&t=#{sec}"
  end
end
