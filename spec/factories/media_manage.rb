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

  factory :media_manage_other_site, class: MediaManage do
    association :user, factory: :alice
    title { 'その他の動画' }
    media_url { 'https://www.example.com/watch?v=abcdefg' }
    media_sec { 3723 }
  end
end
