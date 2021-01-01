# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediaManage, type: :model do
  let!(:media_manage) { create(:media_manage) }

  def add_spans(hash)
    media_manage.media_time_span.create(hash)
  end

  context 'time_spans' do
    it '現在のseqのデータのみが取得できること' do
      add_spans({ seq_id: 1, begin_sec: 0, end_sec: 10 })
      add_spans({ seq_id: 2, begin_sec: 0, end_sec: 20 })
      add_spans({ seq_id: 3, begin_sec: 0, end_sec: 30 })
      media_manage.update(curr_seq_id: 2)
      time_spans = media_manage.time_spans

      expect(time_spans.count).to eq 1
      expect(time_spans[0].end_sec).to eq 20
    end

    it 'ソートされていること' do
      add_spans({ seq_id: 1, begin_sec: 1, end_sec: 10 })
      add_spans({ seq_id: 1, begin_sec: 0, end_sec: 10 })
      add_spans({ seq_id: 1, begin_sec: 10, end_sec: 15 })
      add_spans({ seq_id: 1, begin_sec: 0, end_sec: 20 })
      media_manage.update(curr_seq_id: 1)
      time_spans = media_manage.time_spans

      expect(time_spans.count).to eq 4
      expect(time_spans[0].begin_sec).to eq 0
      expect(time_spans[0].end_sec).to eq 10
      expect(time_spans[1].begin_sec).to eq 0
      expect(time_spans[1].end_sec).to eq 20
      expect(time_spans[2].begin_sec).to eq 1
      expect(time_spans[2].end_sec).to eq 10
      expect(time_spans[3].begin_sec).to eq 10
      expect(time_spans[3].end_sec).to eq 15
    end
  end

  context 'can_restore' do
    it 'ひとつ前に戻れるときtrueを返すこと' do
      add_spans({ seq_id: 1, begin_sec: 0, end_sec: 10 })
      add_spans({ seq_id: 2, begin_sec: 0, end_sec: 20 })
      media_manage.update(curr_seq_id: 2)
      expect(media_manage.can_restore).to be_truthy
    end

    it 'ひとつ前に戻れないときfalseを返すこと' do
      add_spans({ seq_id: 1, begin_sec: 0, end_sec: 10 })
      add_spans({ seq_id: 2, begin_sec: 0, end_sec: 20 })
      media_manage.update(curr_seq_id: 1)
      expect(media_manage.can_restore).to be_falsey
    end

    it 'curr_seq_idが0でも不具合が起きないこと' do
      add_spans({ seq_id: 1, begin_sec: 0, end_sec: 10 })
      add_spans({ seq_id: 2, begin_sec: 0, end_sec: 20 })
      media_manage.update(curr_seq_id: 0)
      expect(media_manage.can_restore).to be_falsey
    end
  end

  context 'youtube_thumbnail_url' do
    subject { media_manage.youtube_thumbnail_url }

    it 'urlがないときnilを返すこと' do
      expect(media_manage.media_url).to be_nil
      is_expected.to be_nil
    end

    it 'urlがyoutubeにマッチしないときnilを返すこと' do
      media_manage.update(media_url: 'https://www.test.com/foo/bar')
      is_expected.to be_nil
    end

    it 'urlがyoutubeにマッチしたときサムネイルのurlを返すこと' do
      media_manage.update(media_url: 'https://www.youtube.com/watch?v=abcdefg12345')
      is_expected.to eq 'https://img.youtube.com/vi/abcdefg12345/mqdefault.jpg'
    end
  end

  context 'cascade' do
    it 'ユーザー削除時に削除されること' do
      expect(MediaManage.count(:id)).to be 1
      media_manage.user.destroy
      expect(MediaManage.count(:id)).to be 0
    end
  end
end
