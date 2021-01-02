# frozen_string_literal: true

FactoryBot.define do
  factory :media_manage do
    association :user
    title { 'media_manageタイトル' }
  end

  factory :media_manage2, class: MediaManage do
    association :user, factory: :user2
    title { 'media_manage_title' }
  end
end
