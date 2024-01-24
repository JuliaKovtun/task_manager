class Project < ApplicationRecord
  has_many :tasks

  scope :with_tasks, -> { includes(:tasks) }
end
