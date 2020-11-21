# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { 'The title' }

    description { 'Some description goes here' }

    sequence(:guid) do |n|
      "guild-#{n}"
    end

    channel

    content { 'The full content is here' }
  end
end
