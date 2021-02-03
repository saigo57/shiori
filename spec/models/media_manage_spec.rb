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

  context 'media_sec_str' do
    it '文字列に変換できること' do
      expect(media_manage.media_sec_str).to eq '01:02:03'
    end

    it 'media_secがnilのとき0秒として扱うこと' do
      media_manage.media_sec = nil
      expect(media_manage.media_sec_str).to eq '00:00:00'
    end
  end

  context 'youtube_video?' do
    subject { media_manage.youtube_video? }

    it 'urlがないときfalseを返すこと' do
      expect(media_manage.media_url).to be_nil
      is_expected.to be_falsey
    end

    it 'urlがyoutubeにマッチしないときfalseを返すこと' do
      media_manage.update(media_url: 'https://www.test.com/foo/bar')
      is_expected.to be_falsey
    end

    it 'urlがwww.youtube.comにマッチしたときtrueを返すこと' do
      media_manage.update(media_url: 'https://www.youtube.com/watch?v=abcdefg12345')
      is_expected.to be_truthy
    end

    it 'urlがyoutu.beにマッチしたときtrueを返すこと' do
      media_manage.update(media_url: 'https://youtu.be/abcdefg12345')
      is_expected.to be_truthy
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

    it 'urlがwww.youtube.comにマッチしたときサムネイルのurlを返すこと' do
      media_manage.update(media_url: 'https://www.youtube.com/watch?v=abcdefg12345')
      is_expected.to eq 'https://img.youtube.com/vi/abcdefg12345/mqdefault.jpg'
    end

    it 'urlがyoutu.beにマッチしたときサムネイルのurlを返すこと' do
      media_manage.update(media_url: 'https://youtu.be/abcdefg12345')
      is_expected.to eq 'https://img.youtube.com/vi/abcdefg12345/mqdefault.jpg'
    end
  end

  context 'watched_seconds' do
    subject { media_manage.watched_seconds }

    before do
      media_manage.media_sec = 3600
    end

    it 'media_secがnilのときnilを返すこと' do
      media_manage.media_sec = nil
      is_expected.to be_nil
    end

    it '視聴時間を返すこと' do
      add_spans({ seq_id: 1, begin_sec: 0, end_sec: 200 })
      is_expected.to eq 200
    end

    it '視聴時間が複数でも正常に計算されること' do
      MediaTimeSpan.transaction do
        add_spans({ seq_id: 1, begin_sec: 100, end_sec: 300 })
        add_spans({ seq_id: 1, begin_sec: 1000, end_sec: 2000 })
      end
      is_expected.to eq 1200
    end

    it '動画時間を超えている分は計算に入れないこと' do
      MediaTimeSpan.transaction do
        add_spans({ seq_id: 1, begin_sec: 100, end_sec: media_manage.media_sec + 100 })
        add_spans({ seq_id: 1, begin_sec: media_manage.media_sec + 200, end_sec: media_manage.media_sec + 300 })
      end
      is_expected.to eq 3500
    end

    it '現在のseqのみ計算に含めること' do
      MediaTimeSpan.transaction do
        add_spans({ seq_id: 1, begin_sec: 0, end_sec: 500 })
        add_spans({ seq_id: 2, begin_sec: 2000, end_sec: 3000 })
        media_manage.update(curr_seq_id: 2)
      end
      is_expected.to eq 1000
    end
  end

  context 'media_status' do
    subject { media_manage.media_status }

    before do
      media_manage.media_sec = 3600
    end

    it 'media_secがnilのとき、専用の文字列を返すこと' do
      media_manage.media_sec = nil
      is_expected.to eq '動画時間が登録されていません'
    end

    it 'media_sec = spansで、視聴済みを返すこと' do
      add_spans({ seq_id: 1, begin_sec: 0, end_sec: 3600 })
      is_expected.to eq '視聴済み'
    end

    it 'media_sec < spansで、視聴済みを返すこと' do
      add_spans({ seq_id: 1, begin_sec: 0, end_sec: 4000 })
      is_expected.to eq '視聴済み'
    end

    it 'media_sec > spansで、視聴中と残り時間を返すこと' do
      add_spans({ seq_id: 1, begin_sec: 0, end_sec: 900 })
      is_expected.to eq '視聴中・のこり00:45:00'
    end

    it 'spanが途中〜途中の場合も、視聴中と残り時間を返すこと' do
      add_spans({ seq_id: 1, begin_sec: 1000, end_sec: 1900 })
      is_expected.to eq '視聴中・のこり00:45:00'
    end

    it 'spanが途中〜最後の場合も、視聴中と残り時間を返すこと' do
      add_spans({ seq_id: 1, begin_sec: 2700, end_sec: 3600 })
      is_expected.to eq '視聴中・のこり00:45:00'
    end

    it 'spanが複数の場合も、視聴中と残り時間を返すこと' do
      MediaTimeSpan.transaction do
        add_spans({ seq_id: 1, begin_sec: 0, end_sec: 300 })
        add_spans({ seq_id: 1, begin_sec: 1000, end_sec: 1300 })
        add_spans({ seq_id: 1, begin_sec: 2000, end_sec: 2300 })
      end
      is_expected.to eq '視聴中・のこり00:45:00'
    end

    it 'spanのendが動画時間を超えていた場合、超えた分を差し引いてのこり時間を返すこと' do
      add_spans({ seq_id: 1, begin_sec: 2700, end_sec: media_manage.media_sec + 1000 })
      is_expected.to eq '視聴中・のこり00:45:00'
    end

    it 'spanのbegin,endが共に動画時間を超えていた場合、超えた分を差し引いてのこり時間を返すこと' do
      add_spans({ seq_id: 1, begin_sec: 0, end_sec: 900 })
      add_spans({ seq_id: 1, begin_sec: media_manage.media_sec + 1000, end_sec: media_manage.media_sec + 1100 })
      is_expected.to eq '視聴中・のこり00:45:00'
    end
  end

  context 'cascade' do
    let!(:user) { media_manage.user }
    let!(:playlist) { create(:playlist, user: user) }
    let!(:playlist_media_manage) do
      create(:playlist_media_manage, playlist: playlist, media_manage: media_manage)
    end

    it 'ユーザー削除時に削除されること' do
      expect(MediaManage.count(:id)).to be 1
      media_manage.user.destroy
      expect(MediaManage.count(:id)).to be 0
    end

    it 'playlist_media_manage削除時に削除されないこと' do
      expect(MediaManage.count(:id)).to be 1
      playlist_media_manage.destroy
      expect(MediaManage.count(:id)).to be 1
    end
  end
end
