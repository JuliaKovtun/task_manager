class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :title, presence: true, uniqueness: true

  scope :with_tasks, -> { includes(:tasks) }
end
