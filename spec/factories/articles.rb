# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    sequence :title do |n|
      "The title #{n}"
    end

    sequence :description do |n|
      "The description #{n}"
    end

    sequence :guid do |n|
      "guild-#{n}"
    end

    published_at { DateTime.now }

    url { 'http://www.example.com' }

    channel

    content { 'The full content is here' }

    trait :uses_scraper do
      association :channel, :uses_scraper
    end

    trait :does_not_use_scraper do
      association :channel, :does_not_use_scraper
    end

    trait :with_category do
      association :category
    end

    trait :with_group do
      association :group
    end
  end
end
