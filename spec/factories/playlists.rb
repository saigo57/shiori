# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    association :user
    name { 'テストプレイリスト' }
  end

  factory :playlist2, class: Playlist do
    association :user, factory: :user2
    name { 'テストプレイリスト2' }
  end
end
