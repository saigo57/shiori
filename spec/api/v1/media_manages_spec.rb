# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::v1::MediaManages', type: :request do
  let(:user) { create(:user) }
  let(:user2) { create(:user2) }
  let(:media_url) { 'http://testmedia.example.com' }

  before do
    user.confirm
    user2.confirm
  end

  describe 'POST /api/v1/media_manages' do
    it 'ログインしているとき、そのユーザの動画として登録されること' do
      login user
      expect(user.media_manage.where(media_url: media_url).count).to eq 0
      expect(user2.media_manage.where(media_url: media_url).count).to eq 0

      post '/api/v1/media_manages', params: { media_url: media_url }
      expect(response).to have_http_status 201

      expect(user.media_manage.where(media_url: media_url).count).to eq 1
      expect(user2.media_manage.where(media_url: media_url).count).to eq 0
    end

    it 'ログインしていないとき、認証エラーになること' do
      expect(user.media_manage.where(media_url: media_url).count).to eq 0
      expect(user2.media_manage.where(media_url: media_url).count).to eq 0

      post '/api/v1/media_manages', params: { media_url: media_url }
      expect(response).to have_http_status 401

      expect(user.media_manage.where(media_url: media_url).count).to eq 0
      expect(user2.media_manage.where(media_url: media_url).count).to eq 0
    end
  end
end
