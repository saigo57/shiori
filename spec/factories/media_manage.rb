# frozen_string_literal: true

FactoryBot.define do
  factory :media_manage do
    association :user
    title { 'タイトル' }
  end
end
