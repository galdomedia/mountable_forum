# encoding: utf-8

Factory.define :category, :class => SimpleForum::Category do |f|
  f.name "Name"
end

Factory.define :forum, :class => SimpleForum::Forum do |f|
  f.name "Name"
  f.association :category
end

Factory.define :topic, :class => SimpleForum::Topic do |f|
  f.title "Name"
  f.body "bleble"
  f.association :forum
  f.association :user
end

Factory.define :post, :class => SimpleForum::Post do |f|
  f.body "Name"
#  f.association :user
end

Factory.define :user do |f|
  f.sequence(:email) { |n| "email_#{n}@examlpe-email.com" }
  f.password "password"
  f.password_confirmation { |m| m.password }
end
