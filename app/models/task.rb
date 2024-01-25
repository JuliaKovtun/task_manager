class Task < ApplicationRecord
  enum status: { new: 0, in_progress: 1, done: 2 }, _prefix: true

  belongs_to :project

  validates :title, presence: true, uniqueness: true

  scope :with_status, ->(status) { where(status: status) }
end
