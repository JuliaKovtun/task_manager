FactoryBot.define do
  factory :user do
    email { 'user@user.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
