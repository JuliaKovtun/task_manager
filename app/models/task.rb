class Task < ApplicationRecord
  # prefix, because of reserved words
  enum status: { new: 0, in_progress: 1, done: 2 }, _prefix: true

  belongs_to :project, touch: true # for caching invalidation

  validates :title, presence: true, uniqueness: true

  scope :with_status, ->(status) { where(status: status) }
end
