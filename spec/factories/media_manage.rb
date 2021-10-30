# frozen_string_literal: true

FactoryBot.define do
  factory :media_manage do
    association :user
    title { 'media_manageタイトル' }
    media_url { 'http://media_url_test.example.com' }
    media_sec { 3723 }
  end

  factory :media_manage2, class: MediaManage do
    association :user, factory: :user2
    title { 'media_manage_title' }
    media_url { 'http://media_url_test2.example.com' }
  end

  factory :alices_media_manage, class: MediaManage do
    association :user, factory: :alice
    title { 'media_manage_title' }
    media_url { 'http://media_url_alice.example.com' }
  end

  factory :media_manage_other_site, class: MediaManage do
    association :user, factory: :alice
    title { 'その他の動画' }
    media_url { 'https://www.example.com/watch?v=abcdefg' }
    media_sec { 3723 }
  end
end
