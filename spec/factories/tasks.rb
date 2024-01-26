FactoryBot.define do
  factory :task do
    title { 'Test task' }
    description { 'This task is for testing.' }
    status { :new }
    project { create(:project) }
  end
end
