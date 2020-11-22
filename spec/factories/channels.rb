# frozen_string_literal: true

FactoryBot.define do
  factory :channel do
    sequence :title do |n|
      "Title #{n}"
    end

    sequence :url do |n|
      "http://www.example.com/#{n}"
    end

    last_build_date { DateTime.now }

    description { 'This describes the channel' }

    trait :invalid do
      url { nil }
    end

    trait :with_articles do
      transient do
        article_count { 2 }
      end

      after(:create) do |channel, evaluator|
        create_list(:article, evaluator.article_count, channel: channel)
      end
    end
  end
end
