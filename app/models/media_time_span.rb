# frozen_string_literal: true

class MediaTimeSpan < ApplicationRecord
  include CommonModule
  belongs_to :media_manage
  scope :sorted, -> { order('begin_sec').order('end_sec') }
  validates :end_sec, numericality: { greater_than: :begin_sec }

  def begin_time_str
    sec_to_str(begin_sec)
  end

  def end_time_str
    sec_to_str(end_sec)
  end
end
