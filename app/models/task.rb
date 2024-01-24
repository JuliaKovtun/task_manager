class Task < ApplicationRecord
  enum status: { new: 0, in_progress: 1, done: 2 }

  belongs_to :project
end
