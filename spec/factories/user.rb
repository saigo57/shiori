# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end

  factory :user2, class: User do
    email { 'user2@example.com' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end

  factory :alice, class: User do
    email { 'alice@example.com' }
    password { 'alicepassword' }
    password_confirmation { 'alicepassword' }
    confirmed_at { DateTime.now }
  end

  factory :bob, class: User do
    email { 'bob@example.com' }
    password { 'bobpassword' }
    password_confirmation { 'bobpassword' }
    confirmed_at { DateTime.now }
  end
end
