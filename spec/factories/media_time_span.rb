# frozen_string_literal: true

FactoryBot.define do
  factory :media_time_span do
    association :media_manage
    begin_sec { 3723 }
    end_sec { 14_706 }
  end
end
