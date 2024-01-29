# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { 'Test project' }
    description { 'This project is for testing.' }
  end
end
