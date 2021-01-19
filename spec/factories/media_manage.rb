# frozen_string_literal: true

FactoryBot.define do
  factory :media_manage do
    association :user
    title { 'media_manageタイトル' }
    media_sec { 3723 }
  end

  factory :media_manage2, class: MediaManage do
    association :user, factory: :user2
    title { 'media_manage_title' }
  end

  factory :media_manage_rails, class: MediaManage do
    association :user, factory: :alice
    title { '【公式】Railsチュートリアルの歩き方【解説動画】' }
    media_url { 'https://www.youtube.com/watch?v=spbKJhPBGok' }
    media_sec { 3723 }
  end
end
