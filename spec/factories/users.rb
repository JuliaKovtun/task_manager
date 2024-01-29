# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user@user.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
