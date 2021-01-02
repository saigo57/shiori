# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediaTimeSpan, type: :model do
  let!(:media_time_image) { create(:media_time_image) }

  context 'cascade' do
    it 'media_manage削除時に削除されること' do
      expect(MediaTimeImage.count(:id)).to be 1
      media_time_image.media_manage.destroy
      expect(MediaTimeImage.count(:id)).to be 0
    end

    it 'user削除時に削除されること' do
      expect(MediaTimeImage.count(:id)).to be 1
      media_time_image.media_manage.user.destroy
      expect(MediaTimeImage.count(:id)).to be 0
    end
  end
end
