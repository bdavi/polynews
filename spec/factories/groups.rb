# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    category { nil }

    trait :with_category do
      association :category
    end

    trait :with_articles do
      transient do
        article_count { 2 }
      end

      after(:create) do |group, evaluator|
        create_list(:article, evaluator.article_count, group: group)
      end
    end
  end
end
