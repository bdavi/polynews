# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    category { nil }

    trait :featured do
      cached_article_count { 4 }
      cached_has_primary_image { true }
    end

    trait :emphasized do
      cached_article_count { 2 }
      cached_has_primary_image { true }
    end

    trait :minimized_by_count do
      cached_article_count { 1 }
      cached_has_primary_image { true }
    end

    trait :minimized_by_absence_of_image do
      cached_article_count { 4 }
      cached_has_primary_image { false }
    end

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
