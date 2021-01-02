# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediaTimeSpan, type: :model do
  let!(:media_time_span) { create(:media_time_span) }

  context 'validation' do
    it 'begin_sec < end_secのときvalidになること' do
      expect(media_time_span).to be_valid
    end

    it 'begin_sec > end_secのときinvalidになること' do
      media_time_span.end_sec = 0
      expect(media_time_span).to be_invalid
    end

    it 'begin_sec == end_secのときinvalidになること' do
      media_time_span.end_sec = media_time_span.begin_sec
      expect(media_time_span).to be_invalid
    end
  end

  context 'begin/end_time_str' do
    it '時間が文字列で取得できること' do
      expect(media_time_span.begin_time_str).to eq '01:02:03'
      expect(media_time_span.end_time_str).to eq '04:05:06'
    end
  end

  context 'cascade' do
    it 'media_manage削除時に削除されること' do
      expect(MediaTimeSpan.count(:id)).to be 1
      media_time_span.media_manage.destroy
      expect(MediaTimeSpan.count(:id)).to be 0
    end

    it 'user削除時に削除されること' do
      expect(MediaTimeSpan.count(:id)).to be 1
      media_time_span.media_manage.user.destroy
      expect(MediaTimeSpan.count(:id)).to be 0
    end
  end
end
