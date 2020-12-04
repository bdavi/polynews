# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence :title do |n|
      "The title #{n}"
    end

    sequence :slug do |n|
      "the_slug_#{n}"
    end

    sequence :sort_order do |n|
      n
    end

    trait :with_channels do
      transient do
        channel_count { 2 }
      end

      after(:create) do |category, evaluator|
        create_list(:channel, evaluator.channel_count, category: category)
      end
    end
  end
end
