# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    sequence :title do |n|
      "The title #{n}"
    end

    sequence :description do |n|
      "The description #{n}"
    end

    sequence(:guid) do |n|
      "guild-#{n}"
    end

    channel

    content { 'The full content is here' }
  end
end
