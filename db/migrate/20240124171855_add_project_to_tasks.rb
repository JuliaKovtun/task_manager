# frozen_string_literal: true

class AddProjectToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :project
  end
end
