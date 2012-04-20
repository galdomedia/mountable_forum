require "factory_girl"

FactoryGirl.define do
  factory :category, :class => SimpleForum::Category do
    name "Name"
  end

  factory :forum, :class => SimpleForum::Forum do
    name "Name"
    association :category
  end

  factory :topic, :class => SimpleForum::Topic do
    title "Name"
    body "bleble"
    association :forum
    association :user
  end

  factory :post, :class => SimpleForum::Post do
    body "Name"
#  association :user
  end

  factory :user do
    sequence(:email) { |n| "email_#{n}@example.com" }
    password "password"
    password_confirmation { |m| m.password }
  end
end