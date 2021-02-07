# frozen_string_literal: true

class MediaTimeSpan < ApplicationRecord
  include CommonModule
  belongs_to :media_manage
  scope :sorted, -> { order('begin_sec').order('end_sec') }
  validates :end_sec, numericality: { greater_than: :begin_sec }
  after_create :tell_media_manage_to_change
  after_destroy :tell_media_manage_to_change
  before_commit :update_media_denormalized

  def begin_time_str
    sec_to_str(begin_sec)
  end

  def end_time_str
    sec_to_str(end_sec)
  end

  private

  def tell_media_manage_to_change
    media_manage.span_changed = true
  end

  def update_media_denormalized
    media_manage.update_denormalized
  end
end
